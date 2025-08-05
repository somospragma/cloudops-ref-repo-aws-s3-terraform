# ============================================================================
# VARIABLES PARA EL EJEMPLO
# ============================================================================

variable "client" {
  description = "Nombre del cliente para recursos y etiquetado"
  type        = string
}

variable "project" {
  description = "Nombre del proyecto para recursos y etiquetado"
  type        = string
}

variable "environment" {
  description = "Entorno de despliegue (dev, staging, prod)"
  type        = string
}

variable "profile" {
  description = "Perfil de AWS a utilizar"
  type        = string
}

variable "common_tags" {
  description = "Etiquetas comunes para todos los recursos"
  type        = map(string)
}
