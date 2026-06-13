variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "data_lake_bucket_name" {
  description = "Data lake S3 bucket name"
  type        = string
}

variable "data_lake_bucket_arn" {
  description = "Data lake S3 bucket ARN"
  type        = string
}

variable "kms_key_arn" {
  description = "KMS key ARN"
  type        = string
}

variable "watermark_table_arn" {
  description = "DynamoDB watermark table ARN"
  type        = string
}

variable "pipeline_audit_table_arn" {
  description = "DynamoDB pipeline audit table ARN"
  type        = string
}