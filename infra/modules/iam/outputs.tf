output "lambda_extractor_role_name" {
  value = aws_iam_role.lambda_extractor_role.name
}

output "lambda_extractor_role_arn" {
  value = aws_iam_role.lambda_extractor_role.arn
}

output "glue_job_role_name" {
  value = aws_iam_role.glue_job_role.name
}

output "glue_job_role_arn" {
  value = aws_iam_role.glue_job_role.arn
}

output "stepfunctions_role_name" {
  value = aws_iam_role.stepfunctions_role.name
}

output "stepfunctions_role_arn" {
  value = aws_iam_role.stepfunctions_role.arn
}

output "eventbridge_scheduler_role_name" {
  value = aws_iam_role.eventbridge_scheduler_role.name
}

output "eventbridge_scheduler_role_arn" {
  value = aws_iam_role.eventbridge_scheduler_role.arn
}