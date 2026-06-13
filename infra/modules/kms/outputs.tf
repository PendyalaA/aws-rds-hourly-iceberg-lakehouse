output "kms_key_id" {
  value = aws_kms_key.data_lake.key_id
}

output "kms_key_arn" {
  value = aws_kms_key.data_lake.arn
}

output "kms_alias_name" {
  value = aws_kms_alias.data_lake.name
}