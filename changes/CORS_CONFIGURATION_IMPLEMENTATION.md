# Implementación: CORS Configuration

## Resumen
Se agrega soporte para configuración CORS (Cross-Origin Resource Sharing) en los buckets S3 del módulo, permitiendo controlar el acceso cross-origin desde navegadores web.

## Archivos Modificados

| Archivo | Cambio |
|---------|--------|
| `variables.tf` | Agregado atributo `cors_rules` en `s3_buckets_config` + validación de métodos HTTP |
| `locals.tf` | Agregado filtro `buckets_with_cors` |
| `main.tf` | Agregado recurso `aws_s3_bucket_cors_configuration` con dynamic blocks |
| `outputs.tf` | Agregado output `buckets_with_cors` |
| `README.md` | Documentación, ejemplo de uso y mejores prácticas |

## Estructura de la Variable

```hcl
cors_rules = optional(list(object({
  id              = optional(string, null)
  allowed_headers = optional(list(string), ["*"])
  allowed_methods = list(string)           # GET, PUT, POST, DELETE, HEAD
  allowed_origins = list(string)           # dominios permitidos
  expose_headers  = optional(list(string), [])
  max_age_seconds = optional(number, 3600)
})), [])
```

## Validaciones

- `allowed_methods` solo acepta: `GET`, `PUT`, `POST`, `DELETE`, `HEAD`

## Recurso Terraform Creado

- `aws_s3_bucket_cors_configuration.this` — Se crea solo para buckets que tengan `cors_rules` con al menos una regla configurada.

## Ejemplo de Uso

```hcl
s3_buckets_config = {
  "frontend-assets" = {
    cors_rules = [
      {
        id              = "allow-webapp"
        allowed_methods = ["GET", "HEAD"]
        allowed_origins = ["https://app.midominio.com"]
        allowed_headers = ["*"]
        expose_headers  = ["ETag"]
        max_age_seconds = 3600
      }
    ]
  }
}
```

## Compatibilidad

- No introduce breaking changes
- El atributo es `optional` con default `[]` (sin CORS configurado)
- Compatible con todas las demás funcionalidades del módulo
