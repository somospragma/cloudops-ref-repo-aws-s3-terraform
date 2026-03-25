# Changelog

Todos los cambios notables a este módulo serán documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
y este proyecto adhiere a [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Soporte para notificaciones SQS (`sqs_notifications`) en eventos S3
- Soporte para notificaciones SNS (`sns_notifications`) en eventos S3
- Recurso unificado `aws_s3_bucket_notification.this` que combina Lambda, SQS y SNS
- Output unificado `buckets_with_notifications` con detalles de los tres tipos
- Ejemplos de uso con SQS y SNS en README y samples
- Documentación de permisos requeridos para SQS (Queue Policy) y SNS (Topic Policy)
- Notas sobre permisos KMS cuando SQS/SNS usan cifrado

### Changed
- Recurso `aws_s3_bucket_notification.lambda` renombrado a `aws_s3_bucket_notification.this`
- Local `buckets_with_lambda_notifications` reemplazado por `buckets_with_notifications`
- Sección de documentación "Lambda Notifications" ampliada a "Event Notifications"

### Removed
- Output `buckets_with_lambda_notifications` (reemplazado por `buckets_with_notifications`) — **BREAKING CHANGE**

## [1.0.0] - 2025-08-05

### Added
- Implementación inicial del módulo CORE de múltiples buckets S3
- Configuración de múltiples buckets S3 con naming automático
- Cifrado configurable (AES256/KMS/DSSE-KMS) con validaciones obligatorias
- Versionado granular con soporte para MFA Delete opcional
- Public Access Block configurable (habilitado por defecto por seguridad)
- Políticas dinámicas con force SSL automático
- Lifecycle Management básico con transiciones IA/Glacier/Deep Archive
- Access Logging configurable con prefijos personalizados
- Transfer Acceleration opcional
- Ownership Controls con opciones BucketOwnerEnforced/BucketOwnerPreferred/ObjectWriter
- Object Lock (WORM compliance) opcional con modos GOVERNANCE/COMPLIANCE
- Intelligent Tiering automático opcional con configuración avanzada
- Bucket Key optimization para reducir costos de KMS
- Tags obligatorios y additional_tags personalizables
- Validaciones de seguridad obligatorias (cifrado y bloqueo de acceso público)
- Convenciones de nomenclatura automáticas: {client}-{project}-{environment}-s3-{key}
- Outputs descriptivos con información completa de buckets creados
- Ejemplos de uso básico y avanzado
- Documentación completa con README.md estructurado

### Changed
- N/A

### Deprecated
- N/A

### Removed
- N/A

### Fixed
- N/A

### Security
- Cifrado habilitado por defecto para todos los buckets
- Bloqueo de acceso público implementado por defecto
- Force SSL/TLS obligatorio para todas las conexiones
- Validaciones de variables para prevenir configuraciones inseguras
- Políticas de menor privilegio aplicadas automáticamente
- Abort incomplete multipart uploads configurado por defecto (7 días)
