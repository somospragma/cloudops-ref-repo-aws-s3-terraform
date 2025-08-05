# Ejemplo de Uso - Módulo S3 Buckets CORE

## Descripción
Este directorio contiene un ejemplo funcional completo del módulo S3 Buckets CORE que demuestra todas las funcionalidades principales del módulo.

## Estructura
```
sample/
├── README.md                # Esta documentación
├── data.tf                  # Fuentes de datos necesarias
├── main.tf                  # Configuración principal del ejemplo
├── outputs.tf               # Salidas del ejemplo
├── providers.tf             # Configuración de providers
└── terraform.tfvars.sample  # Variables de ejemplo
```

## Uso Rápido

### 1. Preparación
```bash
# Copiar variables de ejemplo
cp terraform.tfvars.sample terraform.tfvars

# Editar variables según tu entorno
vim terraform.tfvars
```

### 2. Despliegue
```bash
terraform init
terraform plan
terraform apply
```

### 3. Verificación
```bash
terraform output
```

### 4. Limpieza
```bash
terraform destroy
```

## Ejemplos de Configuración

### Configuración Mínima
Para un entorno de desarrollo básico:
```hcl
client      = "pragma"
project     = "webapp"
environment = "dev"

s3_buckets_config = {
  "uploads" = {
    force_destroy = true  # Solo para desarrollo
    
    # Configuración mínima (cifrado y seguridad por defecto)
    encryption_enabled = true
    encryption_type    = "AES256"
    versioning_enabled = true
    
    # Lifecycle básico
    lifecycle_rules = [
      {
        id     = "basic-cleanup"
        status = "Enabled"
        
        transition_ia_days = 30
        abort_incomplete_multipart_upload_days = 7
      }
    ]
    
    additional_tags = {
      purpose = "development-uploads"
    }
  }
}
```

### Configuración Completa
Para un entorno de producción con todas las características:
```hcl
client      = "pragma"
project     = "webapp"
environment = "prod"

s3_buckets_config = {
  "backups" = {
    force_destroy = false  # Protección en producción
    
    # Cifrado avanzado con KMS
    encryption_enabled = true
    encryption_type    = "KMS"
    kms_key_id        = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
    bucket_key_enabled = true
    
    # Versionado con protección
    versioning_enabled = true
    
    # Object Lock para compliance (WORM)
    object_lock_enabled = true
    object_lock_configuration = {
      mode = "GOVERNANCE"
      days = 30
    }
    
    # Intelligent Tiering automático
    intelligent_tiering_enabled = true
    intelligent_tiering_config = {
      name   = "production-tiering"
      status = "Enabled"
      prefix = "backups/"
      
      # Habilitar tiers avanzados
      deep_archive_access_tier = true
      archive_access_tier     = true
      
      # Análisis adicional
      optional_fields = ["BucketKeyStatus", "EncryptionStatus"]
    }
    
    # Transfer Acceleration para uploads grandes
    transfer_acceleration_enabled = true
    
    # Lifecycle Management completo
    lifecycle_rules = [
      {
        id     = "comprehensive-lifecycle"
        status = "Enabled"
        
        prefix = "backups/"
        
        # Transiciones de versión actual
        transition_ia_days          = 30
        transition_glacier_days     = 90
        transition_deep_archive_days = 180
        
        # Gestión de versiones no actuales
        noncurrent_version_transition_ia_days      = 30
        noncurrent_version_transition_glacier_days = 60
        noncurrent_version_expiration_days         = 2555  # 7 años
        
        # Limpieza de uploads incompletos
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
    
    # Tags específicos
    additional_tags = {
      purpose    = "backup-storage"
      tier       = "premium"
      compliance = "required"
      retention  = "7-years"
    }
  }
}
```

### Configuración Multi-Bucket
Para múltiples buckets con diferentes propósitos:
```hcl
s3_buckets_config = {
  # Bucket para uploads de usuarios
  "uploads" = {
    encryption_type    = "AES256"
    versioning_enabled = true
    
    lifecycle_rules = [
      {
        id     = "uploads-lifecycle"
        status = "Enabled"
        transition_ia_days = 30
        abort_incomplete_multipart_upload_days = 7
      }
    ]
    
    additional_tags = {
      purpose = "user-uploads"
      tier    = "standard"
    }
  }
  
  # Bucket para logs de acceso
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
  
  # Bucket para backups críticos
  "backups" = {
    encryption_type    = "KMS"
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
      name = "backup-tiering"
      deep_archive_access_tier = true
    }
    
    lifecycle_rules = [
      {
        id     = "backup-lifecycle"
        status = "Enabled"
        
        transition_ia_days          = 30
        transition_glacier_days     = 90
        transition_deep_archive_days = 180
        
        noncurrent_version_expiration_days = 2555  # 7 años
        abort_incomplete_multipart_upload_days = 1
      }
    ]
    
    additional_tags = {
      purpose    = "backup-storage"
      tier       = "premium"
      compliance = "required"
    }
  }
}
```

## Características Demostradas

### ✅ Funcionalidades CORE Incluidas
- **Múltiples buckets S3** con naming automático
- **Cifrado configurable** (AES256/KMS/DSSE-KMS)
- **Versionado granular** con MFA Delete opcional
- **Public Access Block** configurable (habilitado por defecto)
- **Políticas dinámicas** con force SSL automático
- **Lifecycle Management** básico (IA/Glacier/Deep Archive)
- **Access Logging** configurable
- **Transfer Acceleration** opcional
- **Ownership Controls** configurables
- **Object Lock** (WORM compliance) opcional
- **Intelligent Tiering** automático opcional
- **Bucket Key optimization** para KMS
- **Tags obligatorios** y additional_tags

### 🔒 Seguridad Enterprise
- Cifrado habilitado por defecto para todos los buckets
- Acceso público bloqueado por defecto
- Force SSL/TLS obligatorio
- Validaciones de configuración de seguridad
- Políticas de menor privilegio

### 📊 Outputs Disponibles
- Información completa de buckets creados
- Estado de configuraciones de seguridad
- Resumen de características habilitadas
- Información de contexto del despliegue

## Consideraciones

### Seguridad
- ✅ Cifrado habilitado por defecto en todos los buckets
- ✅ Acceso público bloqueado por defecto
- ✅ Conexiones SSL/TLS obligatorias
- ✅ Políticas de menor privilegio aplicadas
- ✅ Logging y auditoría configurables

### Costos
- El módulo incluye optimizaciones de costos como Bucket Key para KMS
- Intelligent Tiering puede reducir costos automáticamente
- Lifecycle rules ayudan a gestionar costos de almacenamiento
- Transfer Acceleration tiene costos adicionales (solo habilitar si es necesario)

### Compliance
- Object Lock disponible para requisitos WORM
- Versionado para auditoría y recuperación
- Logging de acceso para compliance
- Tags obligatorios para governance

## Troubleshooting

### Error: "bucket already exists"
```bash
# El nombre del bucket ya existe globalmente
# Cambiar las variables client, project, environment o la key del bucket
```

### Error: "MFA Delete requires MFA"
```bash
# MFA Delete requiere configuración adicional de MFA
# Para el ejemplo, mantener mfa_delete_enabled = false
```

### Error: "Object Lock requires versioning"
```bash
# Object Lock requiere versionado habilitado
# Asegurar que versioning_enabled = true cuando object_lock_enabled = true
```

Este ejemplo es **completamente funcional** y puede desplegarse sin modificaciones adicionales. Todos los recursos creados siguen las mejores prácticas de seguridad y tienen nombres únicos usando la convención establecida.
