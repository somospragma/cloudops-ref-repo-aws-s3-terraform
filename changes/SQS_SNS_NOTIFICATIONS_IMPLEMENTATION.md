# SQS & SNS Notifications Implementation Summary

## Overview
This document summarizes the implementation of SQS and SNS notification support for the S3 Buckets CORE module, extending the existing Lambda notification functionality.

## Problem
The module only supported Lambda as notification target for S3 events. SQS and SNS are common patterns for event-driven architectures (async processing via queues, fan-out via topics).

Additionally, S3 only allows one `aws_s3_bucket_notification` resource per bucket. The previous implementation used a separate resource (`aws_s3_bucket_notification.lambda`) which would conflict if SQS/SNS were added as independent resources.

## Solution
Unified all three notification types (Lambda, SQS, SNS) into a single `aws_s3_bucket_notification.this` resource with dynamic blocks for each type.

## Changes Made

### 1. Variables (`variables.tf`)
Added `sqs_notifications` and `sns_notifications` to `s3_buckets_config`:
```hcl
sqs_notifications = optional(list(object({
  id            = optional(string, null)
  queue_arn     = string
  events        = list(string)
  filter_prefix = optional(string, null)
  filter_suffix = optional(string, null)
})), [])

sns_notifications = optional(list(object({
  id            = optional(string, null)
  topic_arn     = string
  events        = list(string)
  filter_prefix = optional(string, null)
  filter_suffix = optional(string, null)
})), [])
```

### 2. Locals (`locals.tf`)
Replaced `buckets_with_lambda_notifications` with unified filter:
```hcl
buckets_with_notifications = {
  for k, v in var.s3_buckets_config : k => v
  if length(v.lambda_notifications) > 0 || length(v.sqs_notifications) > 0 || length(v.sns_notifications) > 0
}
```

### 3. Resources (`main.tf`)
Replaced `aws_s3_bucket_notification.lambda` with unified `aws_s3_bucket_notification.this`:
- `dynamic "lambda_function"` block for Lambda notifications
- `dynamic "queue"` block for SQS notifications
- `dynamic "topic"` block for SNS notifications

### 4. Outputs (`outputs.tf`)
Replaced `buckets_with_lambda_notifications` with `buckets_with_notifications` containing all three types.

### 5. Documentation
- Updated README.md with SQS/SNS configuration examples
- Added required permissions documentation (Queue Policy, Topic Policy)
- Added KMS permissions notes for encrypted SQS/SNS
- Added combined example (Lambda + SQS + SNS)
- Updated architecture diagram
- Updated CHANGELOG.md

### 6. Sample Files
- Updated `sample/main.tf` with SQS and SNS examples
- Updated `sample/terraform.tfvars.sample` with SQS and SNS examples

## Breaking Changes
- Output `buckets_with_lambda_notifications` removed, replaced by `buckets_with_notifications`
- Resource address changed from `aws_s3_bucket_notification.lambda` to `aws_s3_bucket_notification.this`
  - Existing deployments will need `terraform state mv` or will see destroy+create

## Required Permissions

### SQS
- `sqs:SendMessage` from `s3.amazonaws.com` principal on the queue
- If KMS encrypted: `kms:GenerateDataKey` + `kms:Decrypt` for S3 service

### SNS
- `sns:Publish` from `s3.amazonaws.com` principal on the topic
- If KMS encrypted: `kms:GenerateDataKey` + `kms:Decrypt` for S3 service

### Lambda (unchanged)
- `aws_lambda_permission` with `s3.amazonaws.com` principal

## Version
This feature will be released in version 1.1.0 of the module.
