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

# Lambda notifications
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
