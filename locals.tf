# ============================================================================
# TRANSFORMACIONES SIMPLES Y NOMBRES DE RECURSOS
# ============================================================================

locals {
  # OBLIGATORIO: Generar nombres consistentes para buckets
  resource_names = {
    for k, v in var.s3_buckets_config : k => "${var.client}-${var.project}-${var.environment}-s3-${k}"
  }
  
  # Filtro simple: Buckets con logging habilitado
  buckets_with_logging = {
    for k, v in var.s3_buckets_config : k => v
    if v.enable_logging && v.log_bucket != null
  }
  
  # Filtro simple: Buckets con Object Lock habilitado
  buckets_with_object_lock = {
    for k, v in var.s3_buckets_config : k => v
    if v.object_lock_enabled
  }
  
  # Filtro simple: Buckets con Intelligent Tiering habilitado
  buckets_with_intelligent_tiering = {
    for k, v in var.s3_buckets_config : k => v
    if v.intelligent_tiering_enabled && v.intelligent_tiering_config != null
  }
  
  # Filtro simple: Buckets con Transfer Acceleration habilitado
  buckets_with_acceleration = {
    for k, v in var.s3_buckets_config : k => v
    if v.transfer_acceleration_enabled
  }
  
  # Filtro simple: Buckets con políticas personalizadas
  buckets_with_policies = {
    for k, v in var.s3_buckets_config : k => v
    if length(v.policy_statements) > 0
  }
  
  # Filtro simple: Buckets con lifecycle rules
  buckets_with_lifecycle = {
    for k, v in var.s3_buckets_config : k => v
    if length(v.lifecycle_rules) > 0
  }
  
  # Filtro simple: Buckets con notificaciones Lambda
  buckets_with_lambda_notifications = {
    for k, v in var.s3_buckets_config : k => v
    if length(v.lambda_notifications) > 0
  }
  
  # Mapeo directo: ARNs de buckets (se calculará después de crear los recursos)
  bucket_arns = {
    for k, v in aws_s3_bucket.this : k => v.arn
  }
}
