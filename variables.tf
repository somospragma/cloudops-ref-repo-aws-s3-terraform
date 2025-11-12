# ============================================================================
# VARIABLES OBLIGATORIAS
# ============================================================================

variable "client" {
  description = "Nombre del cliente para recursos y etiquetado"
  type        = string
  
  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", var.client))
    error_message = "Client debe usar solo minúsculas, números y guiones."
  }
  
  validation {
    condition     = length(var.client) >= 3 && length(var.client) <= 20
    error_message = "Client debe tener entre 3 y 20 caracteres."
  }
}

variable "project" {
  description = "Nombre del proyecto para recursos y etiquetado"
  type        = string
  
  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", var.project))
    error_message = "Project debe usar solo minúsculas, números y guiones."
  }
  
  validation {
    condition     = length(var.project) >= 3 && length(var.project) <= 30
    error_message = "Project debe tener entre 3 y 30 caracteres."
  }
}

variable "environment" {
  description = "Entorno de despliegue (dev, qa, pdn, prod)"
  type        = string
  
  validation {
    condition     = contains(["dev", "qa", "pdn", "prod"], var.environment)
    error_message = "Environment debe ser: dev, qa, pdn, prod."
  }
}

# ============================================================================
# CONFIGURACIÓN PRINCIPAL DE BUCKETS S3
# ============================================================================

variable "s3_buckets_config" {
  description = "Configuración de múltiples buckets S3 con funcionalidades CORE"
  type = map(object({
    # Configuración básica
    force_destroy = optional(bool, false)
    
    # Cifrado (OBLIGATORIO por seguridad)
    encryption_enabled = optional(bool, true)
    encryption_type    = optional(string, "AES256") # AES256, KMS, DSSE-KMS
    kms_key_id        = optional(string, null)
    bucket_key_enabled = optional(bool, true)
    
    # Versionado
    versioning_enabled = optional(bool, true)
    mfa_delete_enabled = optional(bool, false)
    
    # Public Access Block (OBLIGATORIO por seguridad)
    block_public_access = optional(bool, true)
    
    # Políticas de seguridad
    force_ssl = optional(bool, true)
    policy_statements = optional(list(object({
      sid       = string
      effect    = string
      actions   = list(string)
      resources = optional(list(string), [])
      
      principals = optional(object({
        type        = string
        identifiers = list(string)
      }))
      
      condition = optional(list(object({
        test     = string
        variable = string
        values   = list(string)
      })), [])
    })), [])
    
    # Lifecycle Management básico
    lifecycle_rules = optional(list(object({
      id     = string
      status = string
      
      # Filtros
      prefix = optional(string, "")
      tags   = optional(map(string), {})
      
      # Transiciones
      transition_ia_days          = optional(number, null)
      transition_glacier_days     = optional(number, null)
      transition_deep_archive_days = optional(number, null)
      
      # Expiración
      expiration_days = optional(number, null)
      
      # Versiones no actuales
      noncurrent_version_transition_ia_days          = optional(number, null)
      noncurrent_version_transition_glacier_days     = optional(number, null)
      noncurrent_version_transition_deep_archive_days = optional(number, null)
      noncurrent_version_expiration_days             = optional(number, null)
      
      # Multipart uploads
      abort_incomplete_multipart_upload_days = optional(number, 7)
    })), [])
    
    # Access Logging
    enable_logging = optional(bool, false)
    log_bucket     = optional(string, null)
    log_prefix     = optional(string, "access-logs/")
    
    # Transfer Acceleration
    transfer_acceleration_enabled = optional(bool, false)
    
    # Ownership Controls
    object_ownership = optional(string, "BucketOwnerEnforced") # BucketOwnerEnforced, BucketOwnerPreferred, ObjectWriter
    
    # Object Lock (WORM compliance)
    object_lock_enabled = optional(bool, false)
    object_lock_configuration = optional(object({
      mode  = string # GOVERNANCE, COMPLIANCE
      days  = optional(number, null)
      years = optional(number, null)
    }), null)
    
    # Intelligent Tiering
    intelligent_tiering_enabled = optional(bool, false)
    intelligent_tiering_config = optional(object({
      name                                     = string
      status                                   = optional(string, "Enabled")
      prefix                                   = optional(string, "")
      tags                                     = optional(map(string), {})
      deep_archive_access_tier                 = optional(bool, false)
      archive_access_tier                      = optional(bool, false)
    }), null)
    
    # Tags adicionales específicos del bucket
    additional_tags = optional(map(string), {})
  }))
  
  validation {
    condition = alltrue([
      for k, v in var.s3_buckets_config : 
      v.encryption_enabled == true
    ])
    error_message = "Cifrado debe estar habilitado para todos los buckets por seguridad."
  }
  
  validation {
    condition = alltrue([
      for k, v in var.s3_buckets_config : 
      v.block_public_access == true
    ])
    error_message = "Acceso público debe estar bloqueado por defecto para todos los buckets."
  }
  
  validation {
    condition = alltrue([
      for k, v in var.s3_buckets_config : 
      can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", k))
    ])
    error_message = "Las keys de bucket deben usar solo minúsculas, números y guiones."
  }
  
  validation {
    condition = alltrue([
      for k, v in var.s3_buckets_config : 
      length(k) >= 3 && length(k) <= 20
    ])
    error_message = "Las keys de bucket deben tener entre 3 y 20 caracteres."
  }
  
  validation {
    condition = alltrue([
      for k, v in var.s3_buckets_config : 
      contains(["AES256", "KMS", "DSSE-KMS"], v.encryption_type)
    ])
    error_message = "Encryption type debe ser: AES256, KMS, DSSE-KMS."
  }
  
  validation {
    condition = alltrue([
      for k, v in var.s3_buckets_config : 
      contains(["BucketOwnerEnforced", "BucketOwnerPreferred", "ObjectWriter"], v.object_ownership)
    ])
    error_message = "Object ownership debe ser: BucketOwnerEnforced, BucketOwnerPreferred, ObjectWriter."
  }
  
  validation {
    condition = alltrue([
      for k, v in var.s3_buckets_config : 
      v.object_lock_configuration != null ? contains(["GOVERNANCE", "COMPLIANCE"], v.object_lock_configuration.mode) : true
    ])
    error_message = "Object lock mode debe ser: GOVERNANCE, COMPLIANCE."
  }
}
