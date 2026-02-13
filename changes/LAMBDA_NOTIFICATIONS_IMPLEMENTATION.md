# Lambda Notifications Implementation Summary

## Overview
This document summarizes the implementation of Lambda notification support for the S3 Buckets CORE module.

## Changes Made

### 1. Variables (`variables.tf`)
Added `lambda_notifications` configuration to `s3_buckets_config`:
```hcl
lambda_notifications = optional(list(object({
  id                  = optional(string, null)
  lambda_function_arn = string
  events              = list(string)
  filter_prefix       = optional(string, null)
  filter_suffix       = optional(string, null)
})), [])
```

### 2. Locals (`locals.tf`)
Added filter for buckets with Lambda notifications:
```hcl
buckets_with_lambda_notifications = {
  for k, v in var.s3_buckets_config : k => v
  if length(v.lambda_notifications) > 0
}
```

### 3. Resources (`main.tf`)
Added `aws_s3_bucket_notification` resource:
```hcl
resource "aws_s3_bucket_notification" "lambda" {
  provider = aws.project
  for_each = local.buckets_with_lambda_notifications
  bucket   = aws_s3_bucket.this[each.key].id

  dynamic "lambda_function" {
    for_each = each.value.lambda_notifications
    content {
      id                  = lambda_function.value.id
      lambda_function_arn = lambda_function.value.lambda_function_arn
      events              = lambda_function.value.events
      filter_prefix       = lambda_function.value.filter_prefix
      filter_suffix       = lambda_function.value.filter_suffix
    }
  }
}
```

### 4. Outputs (`outputs.tf`)
Added output for Lambda notification details:
```hcl
output "buckets_with_lambda_notifications" {
  description = "Buckets con notificaciones Lambda configuradas"
  value = {
    for k, v in local.buckets_with_lambda_notifications : k => {
      bucket_name = aws_s3_bucket.this[k].id
      notifications = [
        for notif in v.lambda_notifications : {
          id         = notif.id
          lambda_arn = notif.lambda_function_arn
          events     = notif.events
          prefix     = notif.filter_prefix
          suffix     = notif.filter_suffix
        }
      ]
    }
  }
}
```

### 5. Documentation (`README.md`)
- Added Lambda Notifications to features list
- Updated configuration structure with Lambda notifications example
- Added Lambda notifications to outputs table
- Updated advanced example with Lambda processing
- Added dedicated "Ejemplo con Lambda Notifications" section
- Added "Lambda Notifications - Requisitos y Mejores Prácticas" section with:
  - Prerequisites (aws_lambda_permission requirement)
  - Supported S3 events
  - Best practices
  - Limitations

### 6. Sample Files
- Updated `sample/main.tf` with Lambda notifications example bucket
- Updated `sample/terraform.tfvars.sample` with Lambda notifications configuration example

### 7. Changelog (`CHANGELOG.md`)
Added to Unreleased section:
- Lambda Notifications feature
- Multiple triggers support
- Event configuration
- Prefix/suffix filters
- New output
- Documentation updates

## Usage Example

```hcl
module "s3_buckets_core" {
  source = "git::https://github.com/somospragma/terraform-aws-s3-buckets-core.git?ref=v1.1.0"
  
  client      = "pragma"
  project     = "webapp"
  environment = "prod"
  
  s3_buckets_config = {
    "media" = {
      encryption_type    = "AES256"
      versioning_enabled = true
      
      lambda_notifications = [
        {
          id                  = "image-processor"
          lambda_function_arn = aws_lambda_function.image_processor.arn
          events              = ["s3:ObjectCreated:*"]
          filter_prefix       = "images/"
          filter_suffix       = ".jpg"
        }
      ]
    }
  }
}
```

## Prerequisites for Users

1. **Create Lambda Permission First**:
```hcl
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::bucket-name"
}
```

2. **Use depends_on in module call**:
```hcl
module "s3_buckets_core" {
  # ... configuration ...
  
  depends_on = [
    aws_lambda_permission.allow_s3
  ]
}
```

## Supported S3 Events

- `s3:ObjectCreated:*` - Any object creation
- `s3:ObjectCreated:Put` - PUT upload
- `s3:ObjectCreated:Post` - POST upload
- `s3:ObjectCreated:Copy` - Object copy
- `s3:ObjectRemoved:*` - Any deletion
- `s3:ObjectRemoved:Delete` - Specific deletion
- `s3:ObjectRestore:*` - Glacier restoration
- `s3:ReducedRedundancyLostObject` - RRS object loss
- `s3:Replication:*` - Replication events

## Best Practices

1. **Avoid Loops**: Don't write to the same bucket/prefix that triggers the function
2. **Use Specific Filters**: Use `filter_prefix` and `filter_suffix` to reduce invocations
3. **Design for Idempotency**: Lambda functions should handle duplicate events
4. **Configure Timeouts**: Set appropriate Lambda timeouts
5. **Use Dead Letter Queues**: Configure DLQ for failure handling
6. **Monitor**: Use CloudWatch for invocation and error monitoring

## Limitations

- One notification configuration per bucket (but multiple triggers within)
- Prefix/suffix filters cannot overlap between notifications
- Subject to Lambda invocation rate limits

## Testing

To test the implementation:

1. Deploy the module with Lambda notifications configured
2. Upload a file matching the filter criteria
3. Verify Lambda function is invoked via CloudWatch Logs
4. Check S3 bucket notification configuration in AWS Console

## Version

This feature will be released in version 1.1.0 of the module.
