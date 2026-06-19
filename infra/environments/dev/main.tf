locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

module "kms" {
  source = "../../modules/kms"

  project_name = var.project_name
  environment  = var.environment
}

module "s3" {
  source = "../../modules/s3"

  project_name  = var.project_name
  environment   = var.environment
  kms_key_arn   = module.kms.kms_key_arn
  force_destroy = true
}

module "dynamodb" {
  source = "../../modules/dynamodb"

  project_name = var.project_name
  environment  = var.environment
}

module "iam" {
  source = "../../modules/iam"

  project_name             = var.project_name
  environment              = var.environment
  data_lake_bucket_name    = module.s3.bucket_name
  data_lake_bucket_arn     = module.s3.bucket_arn
  kms_key_arn              = module.kms.kms_key_arn
  watermark_table_arn      = module.dynamodb.watermark_table_arn
  pipeline_audit_table_arn = module.dynamodb.pipeline_audit_table_arn
}

module "monitoring" {
  source = "../../modules/monitoring"

  project_name       = var.project_name
  environment        = var.environment
  alert_email        = var.alert_email
  log_retention_days = 14
}

module "vpc" {
  source = "../../modules/vpc"

  project_name = var.project_name
  environment  = var.environment
}