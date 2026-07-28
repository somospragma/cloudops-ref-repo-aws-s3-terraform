# ============================================================================
# OUTPUTS DEL MÓDULO S3 BUCKETS CORE
# ============================================================================

# ARNs de los buckets
output "bucket_arns" {
  description = "ARNs de todos los buckets S3 creados"
  value       = { for k, v in aws_s3_bucket.this : k => v.arn }
}

# IDs de los buckets
output "bucket_ids" {
  description = "IDs de todos los buckets S3 creados"
  value       = { for k, v in aws_s3_bucket.this : k => v.id }
}

# Nombres de los buckets
output "bucket_names" {
  description = "Nombres de todos los buckets S3 creados"
  value       = { for k, v in aws_s3_bucket.this : k => v.bucket }
}

# Domain names de los buckets
output "bucket_domain_names" {
  description = "Domain names de todos los buckets S3 creados"
  value       = { for k, v in aws_s3_bucket.this : k => v.bucket_domain_name }
}

# Regional domain names de los buckets
output "bucket_regional_domain_names" {
  description = "Regional domain names de todos los buckets S3 creados"
  value       = { for k, v in aws_s3_bucket.this : k => v.bucket_regional_domain_name }
}

# Hosted zone IDs de los buckets
output "bucket_hosted_zone_ids" {
  description = "Hosted zone IDs de todos los buckets S3 creados"
  value       = { for k, v in aws_s3_bucket.this : k => v.hosted_zone_id }
}

# Regiones de los buckets
output "bucket_regions" {
  description = "Regiones donde están ubicados los buckets S3"
  value       = { for k, v in aws_s3_bucket.this : k => v.region }
}

# CORS Configuration
output "buckets_with_cors" {
  description = "Buckets con configuración CORS habilitada"
  value = {
    for k, v in local.buckets_with_cors : k => {
      bucket_name = aws_s3_bucket.this[k].id
      cors_rules = [
        for rule in v.cors_rules : {
          id              = rule.id
          allowed_methods = rule.allowed_methods
          allowed_origins = rule.allowed_origins
          allowed_headers = rule.allowed_headers
          expose_headers  = rule.expose_headers
          max_age_seconds = rule.max_age_seconds
        }
      ]
    }
  }
}

# Event notifications (Lambda, SQS, SNS)
output "buckets_with_notifications" {
  description = "Buckets con notificaciones configuradas (Lambda, SQS, SNS, EventBridge)"
  value = {
    for k, v in local.buckets_with_notifications : k => {
      bucket_name         = aws_s3_bucket.this[k].id
      eventbridge_enabled = v.eventbridge_enabled
      lambda_notifications = [
        for n in v.lambda_notifications : {
          id         = n.id
          lambda_arn = n.lambda_function_arn
          events     = n.events
          prefix     = n.filter_prefix
          suffix     = n.filter_suffix
        }
      ]
      sqs_notifications = [
        for n in v.sqs_notifications : {
          id        = n.id
          queue_arn = n.queue_arn
          events    = n.events
          prefix    = n.filter_prefix
          suffix    = n.filter_suffix
        }
      ]
      sns_notifications = [
        for n in v.sns_notifications : {
          id        = n.id
          topic_arn = n.topic_arn
          events    = n.events
          prefix    = n.filter_prefix
          suffix    = n.filter_suffix
        }
      ]
    }
  }
}
