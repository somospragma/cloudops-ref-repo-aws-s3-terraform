resource "aws_s3_bucket" "bucket" {
  for_each = { for item in var.s3_config :
    item.application => {
      "index" : index(var.s3_config, item)
      "application" : item.application
      "accessclass" : item.accessclass
    }
  }
  bucket = join("-", tolist([var.client,  each.key, var.environment, var.functionality, "s3"]))
  tags = merge({ Name = "${join("-", tolist([var.client,  each.key, var.environment, var.functionality, "s3"]))}" },
    { accessclass = each.value.accessclass },
  { application = each.value.application })
}


resource "aws_s3_bucket_server_side_encryption_configuration" "encryption_bucket" {
  for_each = { for item in var.s3_config :
    item.application => {
      "index" : index(var.s3_config, item)
      "application" : item.application
      "kms_key_id" : item.kms_key_id
      "accessclass" : item.accessclass
    }
  }
  bucket = aws_s3_bucket.bucket[each.key].id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = each.value.kms_key_id
      sse_algorithm     = "aws:kms"
    }

  }
}


resource "aws_s3_bucket_ownership_controls" "general_ownership" {
  for_each = { for item in var.s3_config :
    item.application => {
      "index" : index(var.s3_config, item)
      "application" : item.application
      "kms_key_id" : item.kms_key_id
      "accessclass" : item.accessclass
    }
  }
  bucket = aws_s3_bucket.bucket[each.key].id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}



# # Recurso Public Acces Block
resource "aws_s3_bucket_public_access_block" "general_public_access" {
  for_each = { for item in var.s3_config :
    item.application => {
      "index" : index(var.s3_config, item)
      "application" : item.application
      "kms_key_id" : item.kms_key_id
      "accessclass" : item.accessclass
    }
  }
  bucket                  = aws_s3_bucket.bucket[each.key].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


# # Rescurso habilitando versionamiento.
resource "aws_s3_bucket_versioning" "s3_general_versioning" {
  for_each = { for item in var.s3_config :
    item.application => {
      "index" : index(var.s3_config, item)
      "application" : item.application
      "kms_key_id" : item.kms_key_id
      "versioning" : item.versioning
      "accessclass" : item.accessclass
    }
  }
  bucket = aws_s3_bucket.bucket[each.key].id
  versioning_configuration {
    status = each.value.versioning
  }
}

# Recurso politica S3
resource "aws_s3_bucket_policy" "policy" {

  for_each = { for item in var.s3_config :
    item.application => {
      "index" : index(var.s3_config, item)
    } if length(item.statements) > 0
  }
  bucket = aws_s3_bucket.bucket[each.key].id
  policy = data.aws_iam_policy_document.dynamic_policy[each.key].json
}


data "aws_iam_policy_document" "dynamic_policy" {
  for_each = { for item in var.s3_config :
    item.application => {
      "index" : index(var.s3_config, item)
      "statements" : item.statements
    } if length(item.statements) > 0
  }

  dynamic "statement" {
    for_each = each.value["statements"]
    content {
      sid       = statement.value["sid"]
      actions   = statement.value["actions"]
      resources = ["arn:aws:s3:::${join("-", tolist([var.client, each.key, var.environment, var.functionality, "s3/*"]))}"]
      effect    = statement.value["effect"]
      principals {
        type        = statement.value["type"]
        identifiers = statement.value["identifiers"]
      }

      dynamic "condition" {
        for_each = statement.value["condition"]
        content {
          test     = condition.value["test"]
          variable = condition.value["variable"]
          values   = condition.value["values"]
        }
      }
    }
  }
}


resource "aws_lambda_permission" "s3_lambda_permission" {

  for_each = {
    for item in flatten([for s3 in var.s3_config : [for notification in s3.lambda_notifications : {
      "s3_index" : index(var.s3_config, s3)
      "application" : s3.application
      "notification_index" : index(s3.lambda_notifications, notification)
      "lambda_function_arn" : notification.lambda_function_arn
    }]if length(s3.lambda_notifications) > 0 ]) : "${item.s3_index}-notification-${item.notification_index}" => item 
  }
  action        = "lambda:InvokeFunction"
  function_name = each.value["lambda_function_arn"]
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.bucket[each.value["application"]].arn
}


resource "aws_s3_bucket_notification" "bucket_notification" {
  for_each = {
    for item in flatten([for s3 in var.s3_config : [for notification in s3.lambda_notifications : {
      "s3_index" : index(var.s3_config, s3)
      "application" : s3.application
      "notification_index" : index(s3.lambda_notifications, notification)
      "lambda_notifications" : s3.lambda_notifications
    }]]) : "${item.s3_index}-notification-${item.notification_index}" => item
  }
  bucket = aws_s3_bucket.bucket[each.value["application"]].id

  dynamic "lambda_function" {
    for_each = each.value["lambda_notifications"]
    content {
      lambda_function_arn = lambda_function.value["lambda_function_arn"]
      events              = lambda_function.value["events"]
      filter_prefix       = lambda_function.value["filter_prefix"]
      filter_suffix       = lambda_function.value["filter_suffix"]
    }
  }


  depends_on = [
    aws_lambda_permission.s3_lambda_permission
  ]
}


resource "aws_s3_bucket_cors_configuration" "cors" {
  for_each = { for item in var.s3_config :
    item.application => {
      "index" : index(var.s3_config, item)
      "cors_rules" : item.cors_rules
    } if length(item.cors_rules) > 0
  }
  bucket = aws_s3_bucket.bucket[each.key].id

  dynamic "cors_rule" {
    for_each = each.value["cors_rules"]
    content {
      allowed_headers = cors_rule.value["allowed_headers"]
      allowed_methods = cors_rule.value["allowed_methods"]
      allowed_origins = cors_rule.value["allowed_origins"]
      expose_headers  = cors_rule.value["expose_headers"]
    }
  }
}