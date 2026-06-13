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