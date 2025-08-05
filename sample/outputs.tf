# ============================================================================
# OUTPUTS DEL EJEMPLO
# ============================================================================

# ARNs de los buckets
output "bucket_arns" {
  description = "ARNs de todos los buckets S3 creados en el ejemplo"
  value       = module.s3_buckets_core.bucket_arns
}

# IDs de los buckets
output "bucket_ids" {
  description = "IDs de todos los buckets S3 creados en el ejemplo"
  value       = module.s3_buckets_core.bucket_ids
}

# Nombres de los buckets
output "bucket_names" {
  description = "Nombres de todos los buckets S3 creados en el ejemplo"
  value       = module.s3_buckets_core.bucket_names
}

# Domain names de los buckets
output "bucket_domain_names" {
  description = "Domain names de todos los buckets S3 creados en el ejemplo"
  value       = module.s3_buckets_core.bucket_domain_names
}

# Regional domain names de los buckets
output "bucket_regional_domain_names" {
  description = "Regional domain names de todos los buckets S3 creados en el ejemplo"
  value       = module.s3_buckets_core.bucket_regional_domain_names
}

# Información específica para CloudFront (bucket web-content)
output "web_content_bucket_info" {
  description = "Información específica del bucket web-content para uso con CloudFront"
  value = {
    arn                        = module.s3_buckets_core.bucket_arns["web-content"]
    name                       = module.s3_buckets_core.bucket_names["web-content"]
    domain_name               = module.s3_buckets_core.bucket_domain_names["web-content"]
    regional_domain_name      = module.s3_buckets_core.bucket_regional_domain_names["web-content"]
    hosted_zone_id           = module.s3_buckets_core.bucket_hosted_zone_ids["web-content"]
  }
}
