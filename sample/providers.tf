# ============================================================================
# CONFIGURACIÓN DE PROVIDERS PARA EL EJEMPLO
# ============================================================================

terraform {
  required_version = ">= 1.10.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

# Provider principal con default_tags (OBLIGATORIO según reglas)
provider "aws" {
  region = "us-east-1"
  alias = "principal"
  profile = var.profile
  # Sistema de etiquetado de 2 niveles - NIVEL 1: Etiquetas transversales
  default_tags {
    tags = var.common_tags
  }
}