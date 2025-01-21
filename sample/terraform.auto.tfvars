###############################################################
# Variables Globales
###############################################################


aws_region        = "us-east-1"
profile           = "pra_idp_dev"
environment       = "dev"
client            = "pragma"
project           = "hefesto"
service           = "s3"
functionality     = "sample"  


common_tags = {
  environment   = "dev"
  project-name  = "Modulos Referencia"
  cost-center   = "-"
  owner         = "cristian.noguera@pragma.com.co"
  area          = "KCCC"
  provisioned   = "terraform"
  datatype      = "interno"
}


###############################################################
# Variables S3
###############################################################
accessclass = "public"
versioning  = "Enabled"