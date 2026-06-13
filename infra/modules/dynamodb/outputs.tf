output "watermark_table_name" {
  value = aws_dynamodb_table.watermark.name
}

output "watermark_table_arn" {
  value = aws_dynamodb_table.watermark.arn
}

output "pipeline_audit_table_name" {
  value = aws_dynamodb_table.pipeline_audit.name
}

output "pipeline_audit_table_arn" {
  value = aws_dynamodb_table.pipeline_audit.arn
}