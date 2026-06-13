data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "terraform_state" {
  bucket        = var.terraform_state_bucket_name
  force_destroy = false

  tags = {
    Name        = var.terraform_state_bucket_name
    Project     = var.project_name
    Environment = var.environment
    Purpose     = "terraform-remote-state"
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]
}

resource "aws_iam_role" "github_actions_terraform_role" {
  name = "rds-iceberg-${var.environment}-gha-tf-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }

        Action = "sts:AssumeRoleWithWebIdentity"

        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }

          StringLike = {
            "token.actions.githubusercontent.com:sub" = [
              "repo:${var.github_owner}/${var.github_repo}:ref:refs/heads/main",
              "repo:${var.github_owner}/${var.github_repo}:pull_request",
              "repo:${var.github_owner}/${var.github_repo}:ref:refs/heads/feature/*"
            ]
          }
        }
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-${var.environment}-github-actions-terraform-role"
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_iam_policy" "github_actions_terraform_policy" {
  name        = "${var.project_name}-${var.environment}-github-actions-terraform-policy"
  description = "Allows GitHub Actions to deploy Terraform infrastructure"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "AllowTerraformStateBucketAccess"
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ]

        Resource = [
          aws_s3_bucket.terraform_state.arn,
          "${aws_s3_bucket.terraform_state.arn}/*"
        ]
      },
      {
        Sid    = "AllowProjectInfrastructureDeployment"
        Effect = "Allow"

        Action = [
          "s3:*",
          "kms:*",
          "iam:*",
          "ec2:*",
          "rds:*",
          "secretsmanager:*",
          "lambda:*",
          "glue:*",
          "lakeformation:*",
          "athena:*",
          "states:*",
          "scheduler:*",
          "events:*",
          "sns:*",
          "logs:*",
          "dynamodb:*",
          "cloudwatch:*"
        ]

        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "github_actions_terraform_policy_attach" {
  role       = aws_iam_role.github_actions_terraform_role.name
  policy_arn = aws_iam_policy.github_actions_terraform_policy.arn
}