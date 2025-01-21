variable "client" {
  type = string
}
variable "environment" {
  type = string
}
variable "service"{
  type = string  
}
variable "aws_region" {
  type = string
}
variable "profile" {
  type = string
}
variable "common_tags" {
    type = map(string)
    description = "Tags comunes aplicadas a los recursos"
}
variable "project" {
  type = string  
}
variable "functionality" {
  type = string  
}


########### Varibales S3

variable "versioning" {
  type = string
  validation {
    condition     = contains(["Enabled", "Suspended", "Disabled"], var.versioning)
    error_message = "El campo versioning solo puede tomar los valores 'Enabled', 'Suspended' o 'Disabled'."
  }
}

variable "accessclass" {
  type = string
  validation {
    condition     = contains(["public", "private"], var.accessclass)
    error_message = "El campo versioning solo puede tomar los valores 'public' o 'private'"
  }  
}




