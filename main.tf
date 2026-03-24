# ============================================================================
# RECURSOS PRINCIPALES S3
# ============================================================================

# Buckets S3 principales
resource "aws_s3_bucket" "this" {
  provider = aws.project
  for_each = var.s3_buckets_config
  
  bucket        = local.resource_names[each.key]
  force_destroy = each.value.force_destroy
  
  # Object Lock debe habilitarse en la creación del bucket
  object_lock_enabled = each.value.object_lock_enabled
  
  tags = merge(
    {
      Name = local.resource_names[each.key]
    },
    each.value.additional_tags
  )
}

# ============================================================================
# CONFIGURACIÓN DE CIFRADO (OBLIGATORIO)
# ============================================================================

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  provider = aws.project
  for_each = var.s3_buckets_config
  bucket   = aws_s3_bucket.this[each.key].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = each.value.encryption_type == "KMS" ? "aws:kms" : (
        each.value.encryption_type == "DSSE-KMS" ? "aws:kms:dsse" : "AES256"
      )
      kms_master_key_id = each.value.encryption_type != "AES256" ? each.value.kms_key_id : null
    }
    bucket_key_enabled = each.value.encryption_type != "AES256" ? each.value.bucket_key_enabled : null
  }
}

# ============================================================================
# PUBLIC ACCESS BLOCK (OBLIGATORIO POR SEGURIDAD)
# ============================================================================

resource "aws_s3_bucket_public_access_block" "this" {
  provider = aws.project
  for_each = var.s3_buckets_config
  bucket   = aws_s3_bucket.this[each.key].id

  block_public_acls       = each.value.block_public_access
  block_public_policy     = each.value.block_public_access
  ignore_public_acls      = each.value.block_public_access
  restrict_public_buckets = each.value.block_public_access
}

# ============================================================================
# VERSIONADO
# ============================================================================

resource "aws_s3_bucket_versioning" "this" {
  provider = aws.project
  for_each = var.s3_buckets_config
  bucket   = aws_s3_bucket.this[each.key].id
  
  versioning_configuration {
    status     = each.value.versioning_enabled ? "Enabled" : "Suspended"
    mfa_delete = each.value.mfa_delete_enabled ? "Enabled" : "Disabled"
  }
}

# ============================================================================
# OWNERSHIP CONTROLS
# ============================================================================

resource "aws_s3_bucket_ownership_controls" "this" {
  provider = aws.project
  for_each = var.s3_buckets_config
  bucket   = aws_s3_bucket.this[each.key].id

  rule {
    object_ownership = each.value.object_ownership
  }
  
  depends_on = [aws_s3_bucket_public_access_block.this]
}

# ============================================================================
# POLÍTICAS DE BUCKET (FORCE SSL + PERSONALIZADAS)
# ============================================================================

# Política solo Force SSL
resource "aws_s3_bucket_policy" "force_ssl_only" {
  provider = aws.project
  for_each = {
    for k, v in var.s3_buckets_config : k => v
    if v.force_ssl == true && length(v.policy_statements) == 0
  }
  
  bucket = aws_s3_bucket.this[each.key].id
  policy = data.aws_iam_policy_document.force_ssl[each.key].json
  
  depends_on = [aws_s3_bucket_public_access_block.this]
}

# Política combinada (Force SSL + Personalizadas)
resource "aws_s3_bucket_policy" "combined" {
  provider = aws.project
  for_each = local.buckets_with_policies
  
  bucket = aws_s3_bucket.this[each.key].id
  policy = data.aws_iam_policy_document.bucket_policy[each.key].json
  
  depends_on = [aws_s3_bucket_public_access_block.this]
}

# ============================================================================
# LIFECYCLE MANAGEMENT
# ============================================================================

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  provider = aws.project
  for_each = local.buckets_with_lifecycle
  bucket   = aws_s3_bucket.this[each.key].id

  dynamic "rule" {
    for_each = each.value.lifecycle_rules
    content {
      id     = rule.value.id
      status = rule.value.status

      # Filtros - usar prefix vacío como filtro por defecto si no hay otros filtros
      filter {
        # Si hay prefix y tags, usar 'and'
        dynamic "and" {
          for_each = rule.value.prefix != "" && length(rule.value.tags) > 0 ? [1] : []
          content {
            prefix = rule.value.prefix
            tags   = rule.value.tags
          }
        }
        
        # Si solo hay prefix (o ningún filtro), usar prefix
        prefix = rule.value.prefix != "" && length(rule.value.tags) == 0 ? rule.value.prefix : (
          rule.value.prefix == "" && length(rule.value.tags) == 0 ? "" : null
        )
        
        # Si solo hay tags, usarlos
        dynamic "tag" {
          for_each = rule.value.prefix == "" && length(rule.value.tags) > 0 ? rule.value.tags : {}
          content {
            key   = tag.key
            value = tag.value
          }
        }
      }

      # Transiciones de versión actual
      dynamic "transition" {
        for_each = compact([
          rule.value.transition_ia_days != null ? "IA" : null,
          rule.value.transition_glacier_days != null ? "GLACIER" : null,
          rule.value.transition_deep_archive_days != null ? "DEEP_ARCHIVE" : null
        ])
        content {
          days = transition.value == "IA" ? rule.value.transition_ia_days : (
            transition.value == "GLACIER" ? rule.value.transition_glacier_days : rule.value.transition_deep_archive_days
          )
          storage_class = transition.value == "IA" ? "STANDARD_IA" : (
            transition.value == "GLACIER" ? "GLACIER" : "DEEP_ARCHIVE"
          )
        }
      }

      # Expiración de versión actual
      dynamic "expiration" {
        for_each = rule.value.expiration_days != null ? [1] : []
        content {
          days = rule.value.expiration_days
        }
      }

      # Transiciones de versiones no actuales
      dynamic "noncurrent_version_transition" {
        for_each = compact([
          rule.value.noncurrent_version_transition_ia_days != null ? "IA" : null,
          rule.value.noncurrent_version_transition_glacier_days != null ? "GLACIER" : null,
          rule.value.noncurrent_version_transition_deep_archive_days != null ? "DEEP_ARCHIVE" : null
        ])
        content {
          noncurrent_days = noncurrent_version_transition.value == "IA" ? rule.value.noncurrent_version_transition_ia_days : (
            noncurrent_version_transition.value == "GLACIER" ? rule.value.noncurrent_version_transition_glacier_days : rule.value.noncurrent_version_transition_deep_archive_days
          )
          storage_class = noncurrent_version_transition.value == "IA" ? "STANDARD_IA" : (
            noncurrent_version_transition.value == "GLACIER" ? "GLACIER" : "DEEP_ARCHIVE"
          )
        }
      }

      # Expiración de versiones no actuales
      dynamic "noncurrent_version_expiration" {
        for_each = rule.value.noncurrent_version_expiration_days != null ? [1] : []
        content {
          noncurrent_days = rule.value.noncurrent_version_expiration_days
        }
      }

      # Abortar multipart uploads incompletos (SIEMPRE incluido por seguridad)
      abort_incomplete_multipart_upload {
        days_after_initiation = rule.value.abort_incomplete_multipart_upload_days
      }
    }
  }
  
  depends_on = [aws_s3_bucket_versioning.this]
}

# ============================================================================
# ACCESS LOGGING
# ============================================================================

resource "aws_s3_bucket_logging" "this" {
  provider = aws.project
  for_each = local.buckets_with_logging
  bucket   = aws_s3_bucket.this[each.key].id
  
  target_bucket = each.value.log_bucket
  target_prefix = "${each.value.log_prefix}${local.resource_names[each.key]}/"
}

# ============================================================================
# TRANSFER ACCELERATION
# ============================================================================

resource "aws_s3_bucket_accelerate_configuration" "this" {
  provider = aws.project
  for_each = local.buckets_with_acceleration
  bucket   = aws_s3_bucket.this[each.key].id
  status   = "Enabled"
}

# ============================================================================
# OBJECT LOCK CONFIGURATION (WORM COMPLIANCE)
# ============================================================================

resource "aws_s3_bucket_object_lock_configuration" "this" {
  provider = aws.project
  for_each = local.buckets_with_object_lock
  bucket   = aws_s3_bucket.this[each.key].id

  rule {
    default_retention {
      mode  = each.value.object_lock_configuration.mode
      days  = each.value.object_lock_configuration.days
      years = each.value.object_lock_configuration.years
    }
  }
  
  depends_on = [aws_s3_bucket_versioning.this]
}

# ============================================================================
# INTELLIGENT TIERING
# ============================================================================

resource "aws_s3_bucket_intelligent_tiering_configuration" "this" {
  provider = aws.project
  for_each = local.buckets_with_intelligent_tiering
  bucket   = aws_s3_bucket.this[each.key].id
  name     = each.value.intelligent_tiering_config.name

  status = each.value.intelligent_tiering_config.status

  # Filtros opcionales
  dynamic "filter" {
    for_each = each.value.intelligent_tiering_config.prefix != "" || length(each.value.intelligent_tiering_config.tags) > 0 ? [1] : []
    content {
      prefix = each.value.intelligent_tiering_config.prefix != "" ? each.value.intelligent_tiering_config.prefix : null
      tags   = length(each.value.intelligent_tiering_config.tags) > 0 ? each.value.intelligent_tiering_config.tags : null
    }
  }

  # Configuraciones opcionales (opcional_fields no está disponible en el provider actual)

  # Tiers opcionales
  dynamic "tiering" {
    for_each = each.value.intelligent_tiering_config.deep_archive_access_tier ? [1] : []
    content {
      access_tier = "DEEP_ARCHIVE_ACCESS"
      days        = 180
    }
  }

  dynamic "tiering" {
    for_each = each.value.intelligent_tiering_config.archive_access_tier ? [1] : []
    content {
      access_tier = "ARCHIVE_ACCESS"
      days        = 90
    }
  }
}

# ============================================================================
# EVENT NOTIFICATIONS (Lambda, SQS, SNS)
# ============================================================================

resource "aws_s3_bucket_notification" "this" {
  provider = aws.project
  for_each = local.buckets_with_notifications
  bucket   = aws_s3_bucket.this[each.key].id

  # Lambda notifications
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

  # SQS notifications
  dynamic "queue" {
    for_each = each.value.sqs_notifications
    content {
      id            = queue.value.id
      queue_arn     = queue.value.queue_arn
      events        = queue.value.events
      filter_prefix = queue.value.filter_prefix
      filter_suffix = queue.value.filter_suffix
    }
  }

  # SNS notifications
  dynamic "topic" {
    for_each = each.value.sns_notifications
    content {
      id            = topic.value.id
      topic_arn     = topic.value.topic_arn
      events        = topic.value.events
      filter_prefix = topic.value.filter_prefix
      filter_suffix = topic.value.filter_suffix
    }
  }
}
