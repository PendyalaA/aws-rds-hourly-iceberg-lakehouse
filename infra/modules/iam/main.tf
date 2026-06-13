data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  name_prefix = "${var.project_name}-${var.environment}"

  s3_object_arn = "${var.data_lake_bucket_arn}/*"

  lambda_name_pattern = "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:${local.name_prefix}-*"
  glue_job_pattern    = "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:job/${local.name_prefix}-*"
  sfn_pattern         = "arn:aws:states:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:stateMachine:${local.name_prefix}-*"
}

resource "aws_iam_role" "lambda_extractor_role" {
  name = "rds-iceberg-${var.environment}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = "rds-iceberg-${var.environment}-lambda-role"
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_iam_policy" "lambda_extractor_policy" {
  name = "rds-iceberg-${var.environment}-lambda-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "CloudWatchLogs"
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      },
      {
        Sid    = "S3RawAuditAccess"
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = var.data_lake_bucket_arn
      },
      {
        Sid    = "S3ObjectWriteAccess"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = local.s3_object_arn
      },
      {
        Sid    = "DynamoDBWatermarkAuditAccess"
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Resource = [
          var.watermark_table_arn,
          var.pipeline_audit_table_arn
        ]
      },
      {
        Sid    = "KMSAccess"
        Effect = "Allow"
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey",
          "kms:DescribeKey"
        ]
        Resource = var.kms_key_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_extractor_attach" {
  role       = aws_iam_role.lambda_extractor_role.name
  policy_arn = aws_iam_policy.lambda_extractor_policy.arn
}

resource "aws_iam_role" "glue_job_role" {
  name = "rds-iceberg-${var.environment}-glue-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "glue.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = "rds-iceberg-${var.environment}-glue-role"
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_iam_policy" "glue_job_policy" {
  name = "rds-iceberg-${var.environment}-glue-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "CloudWatchLogs"
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:AssociateKmsKey"
        ]
        Resource = "*"
      },
      {
        Sid    = "S3DataLakeAccess"
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ]
        Resource = var.data_lake_bucket_arn
      },
      {
        Sid    = "S3ObjectAccess"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = local.s3_object_arn
      },
      {
        Sid    = "GlueCatalogAccess"
        Effect = "Allow"
        Action = [
          "glue:GetDatabase",
          "glue:GetDatabases",
          "glue:CreateDatabase",
          "glue:UpdateDatabase",
          "glue:GetTable",
          "glue:GetTables",
          "glue:CreateTable",
          "glue:UpdateTable",
          "glue:DeleteTable",
          "glue:GetPartition",
          "glue:GetPartitions",
          "glue:CreatePartition",
          "glue:UpdatePartition",
          "glue:DeletePartition"
        ]
        Resource = "*"
      },
      {
        Sid    = "DynamoDBAuditAccess"
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Resource = [
          var.watermark_table_arn,
          var.pipeline_audit_table_arn
        ]
      },
      {
        Sid    = "KMSAccess"
        Effect = "Allow"
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey",
          "kms:DescribeKey"
        ]
        Resource = var.kms_key_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "glue_job_attach" {
  role       = aws_iam_role.glue_job_role.name
  policy_arn = aws_iam_policy.glue_job_policy.arn
}

resource "aws_iam_role" "stepfunctions_role" {
  name = "rds-iceberg-${var.environment}-sfn-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "states.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = "rds-iceberg-${var.environment}-sfn-role"
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_iam_policy" "stepfunctions_policy" {
  name = "rds-iceberg-${var.environment}-sfn-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "InvokeProjectLambdas"
        Effect = "Allow"
        Action = [
          "lambda:InvokeFunction"
        ]
        Resource = local.lambda_name_pattern
      },
      {
        Sid    = "RunProjectGlueJobs"
        Effect = "Allow"
        Action = [
          "glue:StartJobRun",
          "glue:GetJobRun",
          "glue:GetJobRuns",
          "glue:BatchStopJobRun"
        ]
        Resource = local.glue_job_pattern
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "stepfunctions_attach" {
  role       = aws_iam_role.stepfunctions_role.name
  policy_arn = aws_iam_policy.stepfunctions_policy.arn
}

resource "aws_iam_role" "eventbridge_scheduler_role" {
  name = "rds-iceberg-${var.environment}-scheduler-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "scheduler.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = "rds-iceberg-${var.environment}-scheduler-role"
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_iam_policy" "eventbridge_scheduler_policy" {
  name = "rds-iceberg-${var.environment}-scheduler-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "StartProjectStateMachines"
        Effect = "Allow"
        Action = [
          "states:StartExecution"
        ]
        Resource = local.sfn_pattern
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eventbridge_scheduler_attach" {
  role       = aws_iam_role.eventbridge_scheduler_role.name
  policy_arn = aws_iam_policy.eventbridge_scheduler_policy.arn
}