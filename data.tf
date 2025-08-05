# ============================================================================
# FUENTES DE DATOS
# ============================================================================

# Obtener información de la cuenta actual
data "aws_caller_identity" "current" {
  provider = aws.project
}

# Obtener información de la región actual
data "aws_region" "current" {
  provider = aws.project
}

# Políticas dinámicas para Force SSL
data "aws_iam_policy_document" "force_ssl" {
  provider = aws.project
  for_each = {
    for k, v in var.s3_buckets_config : k => v
    if v.force_ssl == true
  }

  statement {
    sid       = "DenyInsecureConnections"
    effect    = "Deny"
    actions   = ["s3:*"]
    resources = [
      aws_s3_bucket.this[each.key].arn,
      "${aws_s3_bucket.this[each.key].arn}/*"
    ]
    
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

# Políticas dinámicas personalizadas
data "aws_iam_policy_document" "bucket_policy" {
  provider = aws.project
  for_each = local.buckets_with_policies

  # Política Force SSL (siempre incluida si force_ssl está habilitado)
  dynamic "statement" {
    for_each = each.value.force_ssl ? [1] : []
    content {
      sid       = "DenyInsecureConnections"
      effect    = "Deny"
      actions   = ["s3:*"]
      resources = [
        aws_s3_bucket.this[each.key].arn,
        "${aws_s3_bucket.this[each.key].arn}/*"
      ]
      
      principals {
        type        = "*"
        identifiers = ["*"]
      }
      
      condition {
        test     = "Bool"
        variable = "aws:SecureTransport"
        values   = ["false"]
      }
    }
  }

  # Políticas personalizadas adicionales
  dynamic "statement" {
    for_each = each.value.policy_statements
    content {
      sid       = statement.value.sid
      effect    = statement.value.effect
      actions   = statement.value.actions
      resources = length(statement.value.resources) > 0 ? statement.value.resources : [
        aws_s3_bucket.this[each.key].arn,
        "${aws_s3_bucket.this[each.key].arn}/*"
      ]
      
      dynamic "principals" {
        for_each = statement.value.principals != null ? [statement.value.principals] : []
        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }
      
      dynamic "condition" {
        for_each = statement.value.condition
        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}
