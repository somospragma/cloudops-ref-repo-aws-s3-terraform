# ============================================================================
# FUENTES DE DATOS PARA EL EJEMPLO
# ============================================================================

# Obtener información de la cuenta actual
data "aws_caller_identity" "current" {
  provider = aws.principal
}

# Obtener información de la región actual
data "aws_region" "current" {
  provider = aws.principal
}

# Obtener la clave KMS por defecto de S3 (opcional para el ejemplo)
data "aws_kms_alias" "s3" {
  provider = aws.principal
  name = "alias/aws/s3"
}

# Obtener una clave KMS existente para contenido web (ejemplo)
# En un entorno real, esta clave debería existir previamente
# data "aws_kms_key" "web_content" {
#   provider = aws.principal
#   key_id = "alias/web-content-encryption"
# }
