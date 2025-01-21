module "s3" {
  source = "./module/s3"

  client            = var.client
  functionality     = var.functionality
  environment       = var.environment
  s3_config = [
  {
    application = var.project
    kms_key_id  = ""  # Cuando se deja vacio usa automaticamente la KMS aws/s3
    accessclass = var.accessclass
    versioning  = var.versioning
    lambda_notifications = [
      # {
      #   lambda_function_arn = ""
      #   events              = ["s3:ObjectCreated:*"]
      #   filter_prefix       = "images/"
      #   filter_suffix       = ".jpg"
      # }
    ]
    statements = [
      {
        sid         = "AllowReadAccess"
        actions     = ["s3:*"]
        effect      = "Allow"
        type        = "AWS"
        identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
        condition = [
          {
          test          = "StringLike"
          variable      = "aws:RequestTag/project"
          values        = ["hefesto"]
          }
        ]
      }
    ]
    cors_rules = [
      {
        allowed_headers = ["*"]
        allowed_methods = ["GET", "POST"]
        allowed_origins = ["https://sample.com"]
        expose_headers  = ["ETag"]
      }
    ]
  }
]
}