# ============================================================================
# EJEMPLO FUNCIONAL DEL MÓDULO S3 BUCKETS CORE
# ============================================================================

# ============================================================================
# MÓDULO S3 BUCKETS CORE
# ============================================================================

module "s3_buckets_core" {
  source = "../"
  providers = {
    aws.project = aws.principal
  }

  # Variables obligatorias
  client      = var.client
  project     = var.project
  environment = var.environment

  # Configuración de buckets
  s3_buckets_config = {
    # Bucket básico con configuración mínima
    "uploads" = {
      # Configuración básica
      force_destroy = true # Solo para el ejemplo, en producción usar false

      # Cifrado básico AES256
      encryption_enabled = true
      encryption_type    = "AES256"

      # Versionado habilitado
      versioning_enabled = true

      # Seguridad por defecto
      block_public_access = true
      force_ssl           = true

      # Tags específicos
      additional_tags = {
        purpose = "file-uploads"
        tier    = "standard"
      }
    }

    # Bucket avanzado con todas las características
    "backups" = {
      # Configuración básica
      force_destroy = true # Solo para el ejemplo

      # Cifrado KMS con clave por defecto
      encryption_enabled = true
      encryption_type    = "KMS"
      kms_key_id         = data.aws_kms_alias.s3.target_key_arn
      bucket_key_enabled = true

      # Versionado con MFA Delete
      versioning_enabled = true
      mfa_delete_enabled = false # Cambiar a true en producción si se requiere

      # Object Lock para compliance
      object_lock_enabled = true
      object_lock_configuration = {
        mode  = "GOVERNANCE"
        years = 1
      }

      # Seguridad estricta
      block_public_access = true
      force_ssl           = true

      # Lifecycle para backups (optimizado para retención a largo plazo)
      lifecycle_rules = [
        {
          id     = "backup-lifecycle"
          status = "Enabled"

          # Transiciones optimizadas para backups
          transition_ia_days           = 30  # Backups antiguos a IA después de 30 días
          transition_glacier_days      = 90  # Archivado a Glacier después de 90 días
          transition_deep_archive_days = 365 # Deep Archive después de 1 año

          # Gestión de versiones no actuales
          noncurrent_version_transition_ia_days      = 30
          noncurrent_version_transition_glacier_days = 90
          noncurrent_version_expiration_days         = 2555 # 7 años de retención

          # Abortar uploads incompletos
          abort_incomplete_multipart_upload_days = 7
        }
      ]

      # Ownership estricto
      object_ownership = "BucketOwnerEnforced"

      # Tags específicos
      additional_tags = {
        purpose    = "backups"
        tier       = "critical"
        compliance = "required"
        retention  = "7-years"
      }
    }

    # Bucket para logs de acceso
    "logs" = {
      # Configuración básica
      force_destroy = true # Solo para el ejemplo

      # Cifrado básico para logs
      encryption_enabled = true
      encryption_type    = "AES256"

      # Sin versionado para logs (optimización de costos)
      versioning_enabled = false

      # Seguridad por defecto
      block_public_access = true
      force_ssl           = true

      # Ownership para logs
      object_ownership = "BucketOwnerPreferred"

      # Tags específicos
      additional_tags = {
        purpose = "access-logs"
        tier    = "logs"
      }
    }

    # Bucket para contenido web con CloudFront
    "web-content" = {
      # Configuración básica
      force_destroy = true # Solo para el ejemplo

      # Cifrado con KMS usando clave existente
      encryption_enabled = true
      # encryption_type    = "KMS"
      # kms_key_id        = data.aws_kms_key.web_content.arn
      encryption_enabled = true
      encryption_type    = "AES256"

      bucket_key_enabled = true

      # Versionado habilitado para contenido web
      versioning_enabled = true
      mfa_delete_enabled = false

      # Seguridad estricta - privado por defecto
      block_public_access = true
      force_ssl           = true

      # Política específica para CloudFront Origin Access Control (OAC)
      policy_statements = [
        {
          sid    = "AllowCloudFrontServicePrincipal"
          effect = "Allow"
          actions = [
            "s3:GetObject"
          ]

          principals = {
            type        = "Service"
            identifiers = ["cloudfront.amazonaws.com"]
          }

          condition = [
            {
              test     = "StringEquals"
              variable = "AWS:SourceArn"
              values   = ["arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/*"]
            }
          ]
        }
      ]

      # Ownership estricto para contenido web
      object_ownership = "BucketOwnerEnforced"

      # Tags específicos para contenido web
      additional_tags = {
        purpose      = "web-content"
        tier         = "production"
        cloudfront   = "enabled"
        content_type = "static-web"
      }
    }

    # Bucket con Lambda notifications para procesamiento automático
    "media" = {
      # Configuración básica
      force_destroy = true # Solo para el ejemplo

      # Cifrado básico
      encryption_enabled = true
      encryption_type    = "AES256"

      # Versionado habilitado
      versioning_enabled = true

      # Seguridad por defecto
      block_public_access = true
      force_ssl           = true

      # EventBridge: enviar todos los eventos al bus por defecto
      # No requiere permisos adicionales, solo crear reglas en EventBridge
      eventbridge_enabled = true

      # Lambda notifications para procesamiento automático
      # NOTA: Requiere aws_lambda_permission configurado previamente
      lambda_notifications = [
        # {
        #   id                  = "image-processor"
        #   lambda_function_arn = "arn:aws:lambda:us-east-1:123456789012:function:process-images"
        #   events              = ["s3:ObjectCreated:*"]
        #   filter_prefix       = "images/"
        #   filter_suffix       = ".jpg"
        # }
      ]

      # SQS notifications para procesamiento asíncrono
      # NOTA: Requiere SQS Queue Policy que permita s3:SendMessage
      sqs_notifications = [
        # {
        #   id            = "upload-queue"
        #   queue_arn     = "arn:aws:sqs:us-east-1:123456789012:media-upload-queue"
        #   events        = ["s3:ObjectCreated:*"]
        #   filter_prefix = "uploads/"
        # }
      ]

      # SNS notifications para fan-out de eventos
      # NOTA: Requiere SNS Topic Policy que permita s3:Publish
      sns_notifications = [
        # {
        #   id            = "media-events"
        #   topic_arn     = "arn:aws:sns:us-east-1:123456789012:media-events"
        #   events        = ["s3:ObjectCreated:*", "s3:ObjectRemoved:*"]
        # }
      ]

      # Lifecycle para media
      lifecycle_rules = [
        {
          id     = "media-lifecycle"
          status = "Enabled"

          transition_ia_days      = 30
          transition_glacier_days = 90

          abort_incomplete_multipart_upload_days = 7
        }
      ]

      # Tags específicos
      additional_tags = {
        purpose = "media-processing"
        tier    = "standard"
      }
    }
  }
}
