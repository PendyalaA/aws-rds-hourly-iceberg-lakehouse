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