# **🚀 Módulo Terraform para s3: cloudops-ref-repo-aws-s3-terraform**

## Descripción:

Este módulo de Terraform permite la creación y configuración de buckets de S3 en AWS con funcionalidades como:

- **Cifrado del lado del servidor:** Configurado mediante AWS KMS.
- **Controles de propiedad:** Establece la propiedad de objetos en el bucket.
- **Bloqueo de acceso público:** Impide accesos públicos no deseados.
- **Versionado:** Habilita o suspende el versionado de objetos.
- **Políticas personalizadas:** Aplica políticas al bucket mediante `aws_s3_bucket_policy`.
- **Notificaciones a funciones Lambda:** Permite configurar notificaciones de eventos de S3 para invocar funciones Lambda.
- **Configuración CORS:** Define reglas CORS para permitir solicitudes desde orígenes específicos.

Requiere previamente haber creado:

- **kms_key_id:** kms_key_id (En caso de que se desee encriptar con ese metodo).
- **lambda_function_arn:** ARN de la lambda (En caso de que se desee utilizar la lambda para enviar notificaciones).


Consulta CHANGELOG.md para la lista de cambios de cada versión. *Recomendamos encarecidamente que en tu código fijes la versión exacta que estás utilizando para que tu infraestructura permanezca estable y actualices las versiones de manera sistemática para evitar sorpresas.*

## Estructura del Módulo

El módulo cuenta con la siguiente estructura:

```bash
cloudops-ref-repo-aws-s3-terraform/
└── sample/
    ├── data.tf
    ├── main.tf
    ├── outputs.tf
    ├── providers.tf
    ├── terraform.auto.tfvars
    └── variables.tf
├── CHANGELOG.md
├── README.md
├── main.tf
├── outputs.tf
├── variables.tf
```

- Los archivos principales del módulo (`main.tf`, `outputs.tf`, `variables.tf`) se encuentran en el directorio raíz.
- `CHANGELOG.md` y `README.md` también están en el directorio raíz para fácil acceso.
- La carpeta `sample/` contiene un ejemplo de implementación del módulo.


## Uso del Módulo:

```hcl
module "s3" {
  source = "./module/s3"

  client            = "xxxx"
  functionality     = "xxxx"
  environment       = "xxxx"
  s3_config = [
  {
    application = "xxxx"
    kms_key_id  = "xxxx"  # Cuando se deja vacio usa automaticamente la KMS aws/s3
    accessclass = "xxxx"
    versioning  = "xxxx"
    lambda_notifications = [
      # {
      #   lambda_function_arn = "xxxx"
      #   events              = ["xxxx"]
      #   filter_prefix       = "xxxx"
      #   filter_suffix       = "xxxx"
      # }
    ]
    statements = [
      {
        sid         = "AllowReadAccess"
        actions     = ["s3:*"]
        effect      = "Allow"
        type        = "AWS"
        identifiers = ["xxxx"]
        condition = [
          {
          test          = "StringLike"
          variable      = "aws:RequestTag/project"
          values        = ["xxxx"]
          }
        ]
      }
    ]
    cors_rules = [
      {
        allowed_headers = ["*"]
        allowed_methods = ["GET", "POST"]
        allowed_origins = ["xxxx"]
        expose_headers  = ["ETag"]
      }
    ]
  }
]
}
}
```
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.31.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.project"></a> [aws.project](#provider\_aws) | >= 4.31.0 |

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.encryption_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_ownership_controls.general_ownership](https://registry.terraform.io/providers/-/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_public_access_block.general_public_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_versioning.s3_general_versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_lambda_permission.s3_lambda_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_s3_bucket_notification.bucket_notification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_s3_bucket_cors_configuration.cors](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_cors_configuration) | resource |


## 📌 Variables

| Variable       | Tipo                                                                                                                                                    | Descripción                                                                                                                                                                                               | Predeterminado | Obligatorio |
|----------------|---------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------|-------------|
| `functionality`| string                                                                                                                                                  | Funcionalidad o propósito del bucket.                                                                                                                                                                    | -              | Sí          |
| `client`       | string                                                                                                                                                  | Identificador del cliente.                                                                                                                                                                                | -              | Sí          |
| `environment`  | string                                                                                                                                                  | Entorno en el que se desplegará el bucket (por ejemplo, `dev`, `QA`, `pdn`).                                                                                                                  | -              | Sí          |

---

### `s3_config`

**Tipo:** `list(object)`

**Descripción:** Lista de configuraciones para cada bucket de S3.

**Estructura del objeto:**

```hcl
object({
  application      = string,
  kms_key_id       = string,
  accessclass      = string,
  versioning       = string,
  lambda_notifications = list(object({
    lambda_function_arn = string,
    events              = list(string),
    filter_prefix       = string,
    filter_suffix       = string
  })),
  statements = list(object({
    sid          = string,
    actions      = list(string),
    effect       = string,
    type         = string,
    identifiers  = list(string),
    condition    = list(object({
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
})
```
### 📤 Outputs

| Output      | Descripción                                                                                                                                                                                                                           |
|-------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `s3_info`   | Objeto que mapea cada aplicación (tomada de `s3_config`) a la siguiente información del bucket S3 creado:<br> - **s3_arn:** ARN del bucket.<br> - **s3_id:** ID del bucket.<br> - **s3_domain_name:** Dominio regional del bucket.<br> - **s3_name:** Nombre asignado (según las etiquetas). |

El bloque de output se define de la siguiente forma:

```hcl
output "s3_info" {
   value = {
     for s3 in aws_s3_bucket.bucket :
     s3.tags_all.application => {
       "s3_arn"          : s3.arn,
       "s3_id"           : s3.id,
       "s3_domain_name"  : s3.bucket_regional_domain_name,
       "s3_name"         : s3.tags_all.Name
     }
   }
}

