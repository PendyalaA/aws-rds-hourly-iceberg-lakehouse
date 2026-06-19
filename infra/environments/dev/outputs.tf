output "name_prefix" {
  value = local.name_prefix
}

output "kms_key_arn" {
  value = module.kms.kms_key_arn
}

output "kms_key_id" {
  value = module.kms.kms_key_id
}

output "kms_alias_name" {
  value = module.kms.kms_alias_name
}

output "data_lake_bucket_name" {
  value = module.s3.bucket_name
}

output "data_lake_bucket_arn" {
  value = module.s3.bucket_arn
}

output "watermark_table_name" {
  value = module.dynamodb.watermark_table_name
}

output "watermark_table_arn" {
  value = module.dynamodb.watermark_table_arn
}

output "pipeline_audit_table_name" {
  value = module.dynamodb.pipeline_audit_table_name
}

output "pipeline_audit_table_arn" {
  value = module.dynamodb.pipeline_audit_table_arn
}

output "lambda_extractor_role_arn" {
  value = module.iam.lambda_extractor_role_arn
}

output "glue_job_role_arn" {
  value = module.iam.glue_job_role_arn
}

output "stepfunctions_role_arn" {
  value = module.iam.stepfunctions_role_arn
}

output "eventbridge_scheduler_role_arn" {
  value = module.iam.eventbridge_scheduler_role_arn
}

output "pipeline_alert_topic_arn" {
  value = module.monitoring.pipeline_alert_topic_arn
}

output "pipeline_alert_topic_name" {
  value = module.monitoring.pipeline_alert_topic_name
}

output "cloudwatch_log_group_names" {
  value = module.monitoring.cloudwatch_log_group_names
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "compute_security_group_id" {
  value = module.vpc.compute_security_group_id
}

output "rds_security_group_id" {
  value = module.vpc.rds_security_group_id
}