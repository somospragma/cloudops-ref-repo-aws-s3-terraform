# Módulo Terraform: S3 Buckets CORE

## Descripción
Módulo Terraform CORE para la creación y gestión de múltiples buckets S3 con funcionalidades empresariales. Diseñado para proporcionar una base sólida y reutilizable para el almacenamiento en S3 con todas las características de seguridad, compliance y optimización de costos necesarias para entornos empresariales.

## Diagrama de Arquitectura
```
┌─────────────────────────────────────────────────────────────────┐
│                    S3 Buckets CORE Module                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐             │
│  │   Bucket 1  │  │   Bucket 2  │  │   Bucket N  │             │
│  │             │  │             │  │             │             │
│  │ ┌─────────┐ │  │ ┌─────────┐ │  │ ┌─────────┐ │             │
│  │ │Encryption│ │  │ │Encryption│ │  │ │Encryption│ │             │
│  │ │AES256/KMS│ │  │ │AES256/KMS│ │  │ │AES256/KMS│ │             │
│  │ └─────────┘ │  │ └─────────┘ │  │ └─────────┘ │             │
│  │             │  │             │  │             │             │
│  │ ┌─────────┐ │  │ ┌─────────┐ │  │ ┌─────────┐ │             │
│  │ │Versioning│ │  │ │Versioning│ │  │ │Versioning│ │             │
│  │ │+ MFA Del │ │  │ │+ MFA Del │ │  │ │+ MFA Del │ │             │
│  │ └─────────┘ │  │ └─────────┘ │  │ └─────────┘ │             │
│  │             │  │             │  │             │             │
│  │ ┌─────────┐ │  │ ┌─────────┐ │  │ ┌─────────┐ │             │
│  │ │Public   │ │  │ │Public   │ │  │ │Public   │ │             │
│  │ │Access   │ │  │ │Access   │ │  │ │Access   │ │             │
│  │ │Block    │ │  │ │Block    │ │  │ │Block    │ │             │
│  │ └─────────┘ │  │ └─────────┘ │  │ └─────────┘ │             │
│  └─────────────┘  └─────────────┘  └─────────────┘             │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │              Advanced Features (Optional)               │   │
│  │                                                         │   │
│  │  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐       │   │
│  │  │Object Lock  │ │Intelligent  │ │Transfer     │       │   │
│  │  │(WORM)       │ │Tiering      │ │Acceleration │       │   │
│  │  └─────────────┘ └─────────────┘ └─────────────┘       │   │
│  │                                                         │   │
│  │  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐       │   │
│  │  │Lifecycle    │ │Access       │ │Dynamic      │       │   │
│  │  │Management   │ │Logging      │ │Policies     │       │   │
│  │  └─────────────┘ └─────────────┘ └─────────────┘       │   │
│  │                                                         │   │
│  │  ┌─────────────────────────────────────────────────┐    │   │
│  │  │         Event Notifications                     │    │   │
│  │  │  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌──────────┐│    │   │
│  │  │  │ Lambda  │  │  SQS    │  │  SNS    │  │EventBridge││    │   │
│  │  │  └─────────┘  └─────────┘  └─────────┘  └──────────┘│    │   │
│  │  └─────────────────────────────────────────────────┘    │   │
│  └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

## Características
- ✅ **Múltiples buckets S3** con naming automático y consistente
- ✅ **Cifrado configurable** (AES256/KMS/DSSE-KMS) con validaciones obligatorias
- ✅ **Versionado granular** con soporte para MFA Delete opcional
- ✅ **Public Access Block** configurable (habilitado por defecto por seguridad)
- ✅ **Políticas dinámicas** con force SSL automático y políticas personalizadas
- ✅ **Lifecycle Management** básico con transiciones IA/Glacier/Deep Archive
- ✅ **Access Logging** configurable con prefijos personalizados
- ✅ **Transfer Acceleration** opcional para uploads grandes
- ✅ **Ownership Controls** configurables (BucketOwnerEnforced/BucketOwnerPreferred/ObjectWriter)
- ✅ **Object Lock** (WORM compliance) opcional con modos GOVERNANCE/COMPLIANCE
- ✅ **Intelligent Tiering** automático opcional con configuración avanzada
- ✅ **Bucket Key optimization** para reducir costos de KMS
- ✅ **Event Notifications** (Lambda, SQS, SNS, EventBridge) para procesamiento automático de eventos S3
- ✅ **Tags obligatorios** y additional_tags personalizables por bucket
- ✅ **Validaciones de seguridad** obligatorias para prevenir configuraciones inseguras

## Estructura del Módulo
```
terraform-aws-s3-buckets-core/
├── .gitignore               # Archivos a ignorar
├── CHANGELOG.md             # Historial de cambios
├── README.md                # Documentación principal
├── data.tf                  # Recursos de datos
├── locals.tf                # Variables locales y transformaciones
├── main.tf                  # Recursos principales
├── outputs.tf               # Salidas del módulo
├── providers.tf             # Configuración de providers
├── variables.tf             # Variables de entrada
└── sample/                  # Directorio ejemplo
    ├── README.md            # Documentación ejemplo
    ├── data.tf              # Datos del ejemplo
    ├── main.tf              # Configuración ejemplo
    ├── outputs.tf           # Salidas ejemplo
    ├── providers.tf         # Providers ejemplo
    ├── variables.tf         # Variables ejemplo
    └── terraform.tfvars.sample # Variables ejemplo
```

## Implementación y Configuración

### Requisitos Técnicos
| Requisito | Versión |
|-----------|---------|
| Terraform | >= 1.0 |
| AWS Provider | >= 5.0 |

### Configuración del Provider
```hcl
provider "aws" {
  region = "us-east-1"
  
  default_tags {
    tags = {
      environment = var.environment
      project     = var.project
      owner       = "cloudops"
      client      = var.client
      area        = "infrastructure"
      provisioned = "terraform"
      datatype    = "operational"
    }
  }
}
```

### Convenciones de Nomenclatura
```
{client}-{project}-{environment}-s3-{identifier}
```

**Ejemplos:**
- `pragma-webapp-dev-s3-uploads`
- `pragma-api-prod-s3-backups`
- `pragma-logs-staging-s3-access-logs`

## Parámetros de Entrada

### Variables Obligatorias
| Nombre | Descripción | Tipo | Requerido | Validación |
|--------|-------------|------|-----------|------------|
| client | Nombre del cliente | string | ✅ | Alfanumérico, 3-20 chars |
| project | Nombre del proyecto | string | ✅ | Alfanumérico, 3-30 chars |
| environment | Entorno (dev/staging/prod) | string | ✅ | Valores permitidos |

### Variables de Configuración
| Nombre | Descripción | Tipo | Requerido | Default |
|--------|-------------|------|-----------|---------|
| s3_buckets_config | Configuración de buckets S3 | map(object()) | ✅ | - |

## Estructura de Configuración

### Configuración Principal
```hcl
s3_buckets_config = {
  "bucket-key" = {
    # Configuración básica
    force_destroy = false
    
    # Cifrado (OBLIGATORIO por seguridad)
    encryption_enabled = true
    encryption_type    = "AES256"  # AES256, KMS, DSSE-KMS
    kms_key_id        = null       # Requerido para KMS/DSSE-KMS
    bucket_key_enabled = true      # Optimización de costos KMS
    
    # Versionado
    versioning_enabled = true
    mfa_delete_enabled = false
    
    # Seguridad (OBLIGATORIO)
    block_public_access = true
    force_ssl          = true
    
    # Políticas personalizadas
    policy_statements = [
      {
        sid    = "CustomPolicy"
        effect = "Allow"
        actions = ["s3:GetObject"]
        
        principals = {
          type        = "AWS"
          identifiers = ["arn:aws:iam::123456789012:root"]
        }
        
        condition = [
          {
            test     = "StringEquals"
            variable = "s3:x-amz-server-side-encryption"
            values   = ["AES256"]
          }
        ]
      }
    ]
    
    # Lifecycle Management
    lifecycle_rules = [
      {
        id     = "lifecycle-rule"
        status = "Enabled"
        
        # Filtros
        prefix = "documents/"
        tags   = { "tier" = "standard" }
        
        # Transiciones
        transition_ia_days          = 30
        transition_glacier_days     = 90
        transition_deep_archive_days = 180
        
        # Expiración
        expiration_days = 2555  # 7 años
        
        # Versiones no actuales
        noncurrent_version_transition_ia_days      = 30
        noncurrent_version_transition_glacier_days = 60
        noncurrent_version_expiration_days         = 365
        
        # Multipart uploads
        abort_incomplete_multipart_upload_days = 7
      }
    ]
    
    # Access Logging
    enable_logging = true
    log_bucket     = "my-log-bucket"
    log_prefix     = "access-logs/"
    
    # Transfer Acceleration
    transfer_acceleration_enabled = false
    
    # Ownership Controls
    object_ownership = "BucketOwnerEnforced"
    
    # Object Lock (WORM compliance)
    object_lock_enabled = false
    object_lock_configuration = {
      mode  = "GOVERNANCE"  # GOVERNANCE, COMPLIANCE
      days  = 30
      years = null
    }
    
    # Intelligent Tiering
    intelligent_tiering_enabled = false
    intelligent_tiering_config = {
      name   = "intelligent-tiering"
      status = "Enabled"
      prefix = ""
      tags   = {}
      
      # Campos opcionales para análisis
      optional_fields = ["BucketKeyStatus", "EncryptionStatus"]
      
      # Tiers avanzados
      deep_archive_access_tier = false
      archive_access_tier     = false
    }
    
    # Lambda Notifications
    lambda_notifications = [
      {
        id                  = "process-uploads"
        lambda_function_arn = "arn:aws:lambda:us-east-1:123456789012:function:process-s3-upload"
        events              = ["s3:ObjectCreated:*"]
        filter_prefix       = "uploads/"
        filter_suffix       = ".jpg"
      }
    ]
    
    # SQS Notifications
    sqs_notifications = [
      {
        id            = "upload-queue"
        queue_arn     = "arn:aws:sqs:us-east-1:123456789012:upload-processing-queue"
        events        = ["s3:ObjectCreated:*"]
        filter_prefix = "documents/"
      }
    ]
    
    # SNS Notifications
    sns_notifications = [
      {
        id            = "upload-alerts"
        topic_arn     = "arn:aws:sns:us-east-1:123456789012:s3-upload-alerts"
        events        = ["s3:ObjectCreated:*", "s3:ObjectRemoved:*"]
      }
    ]
    
    # EventBridge Notifications
    eventbridge_enabled = false  # Habilita envío de TODOS los eventos S3 a EventBridge
    
    # Etiquetas adicionales específicas
    additional_tags = {
      purpose = "document-storage"
      tier    = "standard"
    }
  }
}
```

## Valores de Salida
| Nombre | Descripción | Tipo |
|--------|-------------|------|
| bucket_ids | IDs de buckets creados | map(string) |
| bucket_arns | ARNs de buckets creados | map(string) |
| bucket_names | Nombres completos de buckets | map(string) |
| bucket_domain_names | Nombres de dominio de buckets | map(string) |
| bucket_regional_domain_names | Nombres de dominio regionales | map(string) |
| encryption_configuration | Configuración de cifrado | map(object) |
| versioning_status | Estado de versionado | map(string) |
| public_access_block_status | Estado de bloqueo público | map(object) |
| ownership_controls | Controles de propiedad | map(string) |
| buckets_with_object_lock | Buckets con Object Lock | map(string) |
| buckets_with_intelligent_tiering | Buckets con Intelligent Tiering | map(string) |
| buckets_with_acceleration | Buckets con Transfer Acceleration | map(string) |
| buckets_with_logging | Buckets con Access Logging | map(object) |
| buckets_with_notifications | Buckets con notificaciones (Lambda, SQS, SNS, EventBridge) | map(object) |
| module_summary | Resumen de configuración | object |
| account_id | ID de cuenta AWS | string |
| region | Región AWS | string |

## Ejemplos de Uso

### Ejemplo Básico
```hcl
module "s3_buckets_core" {
  source = "git::https://github.com/somospragma/terraform-aws-s3-buckets-core.git?ref=v1.0.0"
  
  client      = "pragma"
  project     = "webapp"
  environment = "dev"
  
  s3_buckets_config = {
    "uploads" = {
      # Configuración mínima con seguridad por defecto
      encryption_enabled = true
      encryption_type    = "AES256"
      versioning_enabled = true
      
      # Lifecycle básico
      lifecycle_rules = [
        {
          id     = "basic-lifecycle"
          status = "Enabled"
          
          transition_ia_days = 30
          abort_incomplete_multipart_upload_days = 7
        }
      ]
      
      additional_tags = {
        purpose = "user-uploads"
      }
    }
  }
  
  providers = {
    aws.project = aws.project
  }
}
```

### Ejemplo Avanzado
```hcl
module "s3_buckets_core" {
  source = "git::https://github.com/somospragma/terraform-aws-s3-buckets-core.git?ref=v1.0.0"
  
  client      = "pragma"
  project     = "webapp"
  environment = "prod"
  
  s3_buckets_config = {
    # Bucket para uploads con Lambda processing
    "uploads" = {
      encryption_type    = "AES256"
      versioning_enabled = true
      
      # Lambda notifications para procesamiento automático
      lambda_notifications = [
        {
          id                  = "image-processor"
          lambda_function_arn = "arn:aws:lambda:us-east-1:123456789012:function:process-images"
          events              = ["s3:ObjectCreated:*"]
          filter_prefix       = "images/"
          filter_suffix       = ".jpg"
        },
        {
          id                  = "video-processor"
          lambda_function_arn = "arn:aws:lambda:us-east-1:123456789012:function:process-videos"
          events              = ["s3:ObjectCreated:Put"]
          filter_prefix       = "videos/"
          filter_suffix       = ".mp4"
        }
      ]
      
      lifecycle_rules = [
        {
          id     = "uploads-lifecycle"
          status = "Enabled"
          
          transition_ia_days = 30
          transition_glacier_days = 90
          
          noncurrent_version_expiration_days = 365
          abort_incomplete_multipart_upload_days = 7
        }
      ]
      
      additional_tags = {
        purpose = "user-uploads"
        tier    = "standard"
      }
    }
    
    # Bucket para backups con todas las características
    "backups" = {
      # Cifrado avanzado con KMS
      encryption_type    = "KMS"
      kms_key_id        = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
      bucket_key_enabled = true
      
      # Versionado con protección
      versioning_enabled = true
      
      # Object Lock para compliance
      object_lock_enabled = true
      object_lock_configuration = {
        mode = "GOVERNANCE"
        days = 30
      }
      
      # Intelligent Tiering para optimización automática
      intelligent_tiering_enabled = true
      intelligent_tiering_config = {
        name   = "backup-tiering"
        status = "Enabled"
        prefix = "backups/"
        
        deep_archive_access_tier = true
        archive_access_tier     = true
        
        optional_fields = ["BucketKeyStatus", "EncryptionStatus"]
      }
      
      # Transfer Acceleration para uploads grandes
      transfer_acceleration_enabled = true
      
      # Lifecycle completo
      lifecycle_rules = [
        {
          id     = "comprehensive-lifecycle"
          status = "Enabled"
          
          prefix = "backups/"
          
          transition_ia_days          = 30
          transition_glacier_days     = 90
          transition_deep_archive_days = 180
          
          noncurrent_version_transition_ia_days      = 30
          noncurrent_version_transition_glacier_days = 60
          noncurrent_version_expiration_days         = 2555  # 7 años
          
          abort_incomplete_multipart_upload_days = 1
        }
      ]
      
      # Políticas personalizadas
      policy_statements = [
        {
          sid    = "AllowCloudTrailAccess"
          effect = "Allow"
          actions = [
            "s3:PutObject",
            "s3:GetBucketAcl"
          ]
          
          principals = {
            type        = "Service"
            identifiers = ["cloudtrail.amazonaws.com"]
          }
          
          condition = [
            {
              test     = "StringEquals"
              variable = "s3:x-amz-acl"
              values   = ["bucket-owner-full-control"]
            }
          ]
        }
      ]
      
      additional_tags = {
        purpose    = "backup-storage"
        tier       = "premium"
        compliance = "required"
        retention  = "7-years"
      }
    }
    
    # Bucket para logs con configuración específica
    "logs" = {
      encryption_type    = "AES256"
      versioning_enabled = false  # Los logs no necesitan versionado
      
      lifecycle_rules = [
        {
          id     = "log-retention"
          status = "Enabled"
          
          transition_ia_days = 7   # Transición rápida para logs
          expiration_days    = 90  # Retención de 90 días
          
          abort_incomplete_multipart_upload_days = 1
        }
      ]
      
      object_ownership = "BucketOwnerPreferred"  # Para logs de servicios
      
      additional_tags = {
        purpose = "access-logs"
        tier    = "logs"
      }
    }
  }
  
  providers = {
    aws.project = aws.project
  }
}
```

### Ejemplo con Lambda Notifications
```hcl
# IMPORTANTE: Crear permisos Lambda antes del módulo S3
resource "aws_lambda_permission" "allow_s3_image_processor" {
  statement_id  = "AllowS3InvokeImageProcessor"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.image_processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::pragma-webapp-prod-s3-media"
}

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
      
      additional_tags = {
        purpose = "media-processing"
      }
    }
  }
  
  providers = {
    aws.project = aws.project
  }
  
  depends_on = [
    aws_lambda_permission.allow_s3_image_processor
  ]
}
```

### Ejemplo con SQS y SNS Notifications
```hcl
# IMPORTANTE: Crear policies de SQS y SNS antes del módulo S3

resource "aws_sqs_queue" "upload_processing" {
  name = "upload-processing-queue"
}

resource "aws_sqs_queue_policy" "allow_s3" {
  queue_url = aws_sqs_queue.upload_processing.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "AllowS3SendMessage"
      Effect    = "Allow"
      Principal = { Service = "s3.amazonaws.com" }
      Action    = "sqs:SendMessage"
      Resource  = aws_sqs_queue.upload_processing.arn
      Condition = {
        ArnEquals = { "aws:SourceArn" = "arn:aws:s3:::pragma-webapp-prod-s3-events" }
      }
    }]
  })
}

resource "aws_sns_topic" "s3_events" {
  name = "s3-event-notifications"
}

resource "aws_sns_topic_policy" "allow_s3" {
  arn = aws_sns_topic.s3_events.arn
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "AllowS3Publish"
      Effect    = "Allow"
      Principal = { Service = "s3.amazonaws.com" }
      Action    = "sns:Publish"
      Resource  = aws_sns_topic.s3_events.arn
      Condition = {
        ArnEquals = { "aws:SourceArn" = "arn:aws:s3:::pragma-webapp-prod-s3-events" }
      }
    }]
  })
}

module "s3_buckets_core" {
  source = "git::https://github.com/somospragma/terraform-aws-s3-buckets-core.git?ref=v1.1.0"
  
  client      = "pragma"
  project     = "webapp"
  environment = "prod"
  
  s3_buckets_config = {
    "events" = {
      encryption_type    = "AES256"
      versioning_enabled = true
      
      # SQS: procesamiento asíncrono de uploads
      sqs_notifications = [
        {
          id            = "upload-queue"
          queue_arn     = aws_sqs_queue.upload_processing.arn
          events        = ["s3:ObjectCreated:*"]
          filter_prefix = "uploads/"
        }
      ]
      
      # SNS: fan-out de eventos de eliminación
      sns_notifications = [
        {
          id            = "deletion-alerts"
          topic_arn     = aws_sns_topic.s3_events.arn
          events        = ["s3:ObjectRemoved:*"]
        }
      ]
      
      additional_tags = {
        purpose = "event-driven-processing"
      }
    }
  }
  
  providers = {
    aws.project = aws.project
  }
  
  depends_on = [
    aws_sqs_queue_policy.allow_s3,
    aws_sns_topic_policy.allow_s3
  ]
}
```

### Ejemplo con EventBridge Notifications
```hcl
# EventBridge no requiere permisos adicionales en el bucket.
# Solo necesitas crear reglas en EventBridge que capturen los eventos.

module "s3_buckets_core" {
  source = "git::https://github.com/somospragma/terraform-aws-s3-buckets-core.git?ref=v1.1.0"
  
  client      = "pragma"
  project     = "webapp"
  environment = "prod"
  
  s3_buckets_config = {
    "data-lake" = {
      encryption_type    = "KMS"
      kms_key_id        = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
      versioning_enabled = true
      
      # Habilitar EventBridge — TODOS los eventos S3 se envían automáticamente
      eventbridge_enabled = true
      
      additional_tags = {
        purpose = "data-lake-ingestion"
      }
    }
  }
  
  providers = {
    aws.project = aws.project
  }
}

# Ejemplo de regla EventBridge para capturar eventos del bucket
resource "aws_cloudwatch_event_rule" "s3_object_created" {
  name        = "s3-data-lake-object-created"
  description = "Captura creación de objetos en el bucket data-lake"

  event_pattern = jsonencode({
    source      = ["aws.s3"]
    detail-type = ["Object Created"]
    detail = {
      bucket = {
        name = [module.s3_buckets_core.bucket_names["data-lake"]]
      }
    }
  })
}

resource "aws_cloudwatch_event_target" "invoke_lambda" {
  rule = aws_cloudwatch_event_rule.s3_object_created.name
  arn  = aws_lambda_function.data_processor.arn
}
```

## Consideraciones de Seguridad
- ✅ **Cifrado habilitado por defecto** para todos los buckets
- ✅ **Acceso público bloqueado por defecto** para prevenir exposición accidental
- ✅ **Conexiones SSL/TLS obligatorias** mediante políticas automáticas
- ✅ **Políticas de menor privilegio** aplicadas por defecto
- ✅ **Validaciones de configuración** para prevenir configuraciones inseguras
- ✅ **Logging y auditoría** configurables para compliance
- ✅ **Object Lock** disponible para requisitos WORM
- ✅ **Versionado** para recuperación y auditoría
- ✅ **Tags obligatorios** para governance y seguimiento

## Event Notifications - Requisitos y Mejores Prácticas

El módulo soporta cuatro tipos de notificaciones de eventos S3: Lambda, SQS, SNS y EventBridge. Se pueden combinar múltiples tipos en un mismo bucket.

> **Importante:** S3 solo permite una configuración de notificaciones por bucket. El módulo unifica automáticamente los cuatro tipos en un solo recurso `aws_s3_bucket_notification`, por lo que pueden coexistir sin conflictos.

### Permisos Requeridos

Cada tipo de notificación requiere permisos específicos configurados ANTES de desplegar el módulo.

#### Lambda — `aws_lambda_permission`
```hcl
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::bucket-name"
}
```

#### SQS — Queue Policy
La cola SQS debe tener una policy que permita a S3 enviar mensajes:
```hcl
resource "aws_sqs_queue_policy" "allow_s3" {
  queue_url = aws_sqs_queue.processing.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowS3SendMessage"
        Effect    = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action   = "sqs:SendMessage"
        Resource = aws_sqs_queue.processing.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = "arn:aws:s3:::bucket-name"
          }
        }
      }
    ]
  })
}
```

> **Nota:** Si la cola SQS usa cifrado con KMS, la clave KMS debe tener permisos para que el servicio S3 pueda generar data keys. Agregar a la key policy:
> ```json
> {
>   "Sid": "AllowS3UseKey",
>   "Effect": "Allow",
>   "Principal": { "Service": "s3.amazonaws.com" },
>   "Action": ["kms:GenerateDataKey", "kms:Decrypt"],
>   "Resource": "*"
> }
> ```

#### SNS — Topic Policy
El topic SNS debe tener una policy que permita a S3 publicar mensajes:
```hcl
resource "aws_sns_topic_policy" "allow_s3" {
  arn = aws_sns_topic.events.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowS3Publish"
        Effect    = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action   = "sns:Publish"
        Resource = aws_sns_topic.events.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = "arn:aws:s3:::bucket-name"
          }
        }
      }
    ]
  })
}
```

> **Nota:** Si el topic SNS usa cifrado con KMS, la clave KMS debe permitir al servicio S3 generar data keys, de forma análoga al caso de SQS.

#### EventBridge — Sin permisos adicionales

EventBridge **no requiere configuración de permisos** en el lado del bucket. Al habilitar `eventbridge_enabled = true`, S3 envía automáticamente **todos** los eventos al bus de eventos por defecto de EventBridge en la misma cuenta y región.

```hcl
# Solo se necesita habilitar en la configuración del bucket:
eventbridge_enabled = true
```

**Ventajas de EventBridge sobre Lambda/SQS/SNS directos:**
- Recibe **todos** los tipos de eventos S3 sin necesidad de especificar filtros
- Soporta filtrado avanzado por content-based filtering en las reglas de EventBridge
- Permite enrutar a múltiples targets (Lambda, SQS, SNS, Step Functions, API Gateway, etc.)
- Soporta archive & replay de eventos
- Integración nativa con más de 20 servicios AWS como targets
- No tiene las limitaciones de prefix/suffix overlapping de las notificaciones S3 tradicionales

**Cuándo usar EventBridge vs Lambda/SQS/SNS directo:**
| Criterio | EventBridge | Lambda/SQS/SNS directo |
|----------|-------------|------------------------|
| Múltiples consumidores | ✅ Fan-out nativo | Requiere SNS + suscripciones |
| Filtrado avanzado | ✅ Content-based filtering | Solo prefix/suffix |
| Replay de eventos | ✅ Archive & replay | No disponible |
| Latencia mínima | ~1s adicional | Más directo |
| Control de prefix/suffix | Via reglas EventBridge | Nativo en notificación |

### Ejemplo Combinado (Lambda + SQS + SNS + EventBridge)
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
      
      # Lambda: procesamiento síncrono de imágenes
      lambda_notifications = [
        {
          id                  = "image-processor"
          lambda_function_arn = aws_lambda_function.image_processor.arn
          events              = ["s3:ObjectCreated:*"]
          filter_prefix       = "images/"
          filter_suffix       = ".jpg"
        }
      ]
      
      # SQS: cola de procesamiento asíncrono
      sqs_notifications = [
        {
          id            = "video-queue"
          queue_arn     = aws_sqs_queue.video_processing.arn
          events        = ["s3:ObjectCreated:*"]
          filter_prefix = "videos/"
        }
      ]
      
      # SNS: fan-out de eventos de eliminación
      sns_notifications = [
        {
          id            = "deletion-alerts"
          topic_arn     = aws_sns_topic.deletion_alerts.arn
          events        = ["s3:ObjectRemoved:*"]
        }
      ]
      
      # EventBridge: enviar todos los eventos al bus por defecto
      eventbridge_enabled = true
      
      additional_tags = {
        purpose = "media-processing"
      }
    }
  }
  
  providers = {
    aws.project = aws.project
  }
  
  depends_on = [
    aws_lambda_permission.allow_s3_image_processor,
    aws_sqs_queue_policy.allow_s3,
    aws_sns_topic_policy.allow_s3
  ]
}
```

### Eventos Soportados
- `s3:ObjectCreated:*` - Cualquier creación de objeto
- `s3:ObjectCreated:Put` - Upload vía PUT
- `s3:ObjectCreated:Post` - Upload vía POST
- `s3:ObjectCreated:Copy` - Copia de objeto
- `s3:ObjectRemoved:*` - Cualquier eliminación
- `s3:ObjectRemoved:Delete` - Eliminación específica
- `s3:ObjectRestore:*` - Restauración desde Glacier
- `s3:ReducedRedundancyLostObject` - Pérdida de objeto RRS
- `s3:Replication:*` - Eventos de replicación

### Mejores Prácticas
1. **Evitar loops**: No escribir al mismo bucket/prefix que dispara la notificación
2. **Filtros específicos**: Usar `filter_prefix` y `filter_suffix` para reducir invocaciones innecesarias
3. **Sin solapamiento de filtros**: Los filtros de prefix/suffix no pueden solaparse entre notificaciones del mismo tipo de evento
4. **Idempotencia**: Diseñar consumidores para manejar eventos duplicados (S3 garantiza at-least-once delivery)
5. **Dead Letter Queue**: Configurar DLQ en SQS y redrive policy para manejar fallos
6. **Monitoreo**: Usar CloudWatch para monitorear invocaciones, mensajes en cola y errores
7. **Permisos con SourceArn**: Siempre usar `Condition` con `aws:SourceArn` en las policies de SQS/SNS para restringir el acceso al bucket específico

### Limitaciones
- Un bucket solo puede tener una configuración de notificaciones (pero múltiples triggers dentro)
- Los filtros de prefix/suffix no pueden solaparse entre notificaciones del mismo evento
- Sujeto a los límites de invocación de Lambda, throughput de SQS y publish rate de SNS
- EventBridge: envía TODOS los eventos del bucket (no se pueden filtrar a nivel de S3, solo en las reglas de EventBridge)
- EventBridge: introduce ~1 segundo adicional de latencia respecto a notificaciones directas

## Optimización de Costos
- **Bucket Key optimization**: Reduce costos de KMS hasta 99%
- **Intelligent Tiering**: Optimización automática de costos de almacenamiento
- **Lifecycle Management**: Transiciones automáticas a clases de almacenamiento más económicas
- **Abort incomplete multipart uploads**: Previene costos por uploads abandonados
- **Transfer Acceleration**: Solo habilitar cuando sea necesario (tiene costos adicionales)

## Compliance y Governance
- **Object Lock (WORM)**: Para requisitos de retención inmutable
- **Versionado**: Para auditoría y recuperación de datos
- **Access Logging**: Para compliance y auditoría de acceso
- **Tags obligatorios**: Para governance y seguimiento de costos
- **Políticas dinámicas**: Para control de acceso granular

## Contribución
Este módulo sigue las convenciones de Pragma CloudOps. Para contribuir:
1. Fork del repositorio
2. Crear rama feature/
3. Seguir las reglas de commit conventional
4. Abrir Pull Request

## Licencia
Proprietary - Pragma S.A.S.

## Soporte
Para soporte técnico, contactar al equipo CloudOps de Pragma.
