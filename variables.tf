variable "s3_config" {
  type = list(object({
    application = string
    kms_key_id = string
    accessclass = string
    versioning = string
    lambda_notifications = list(object({
      lambda_function_arn = string
      events = list(string)
      filter_prefix = string
      filter_suffix = string
    }))
    statements = list(object({
      sid         = string
      actions     = list(string)
      effect      = string
      type        = string
      identifiers = list(string)
      condition = list(object({
        test     = string
        variable = string
        values   = list(string)
      }))
    }))
    cors_rules = list(object({
      allowed_headers = list(string)
      allowed_methods = list(string)
      allowed_origins = list(string)
      expose_headers = list(string)
    }))
  }))
}


variable "functionality" {
  type = string
}

variable "client" {
  type = string
}

variable "environment" {
  type = string
}