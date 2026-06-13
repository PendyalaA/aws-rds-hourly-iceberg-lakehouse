# AWS RDS Hourly Iceberg Lakehouse

## Project Goal

Build an enterprise-style AWS data engineering pipeline that ingests data from Amazon RDS PostgreSQL every hour, lands incremental data into S3, validates the data, and merges it into Apache Iceberg tables.

## Architecture

RDS PostgreSQL
→ Lambda incremental extractor
→ S3 raw landing zone
→ Glue PySpark validation and Iceberg MERGE
→ Apache Iceberg tables on S3
→ Glue Catalog and Lake Formation governance
→ Athena query layer
→ Step Functions orchestration
→ EventBridge hourly schedule
→ CloudWatch logs and SNS alerts

## Key Requirements

- Full Git and Pull Request workflow
- Terraform Infrastructure as Code
- GitHub Actions deployment
- GitHub OIDC authentication to AWS
- IAM least privilege
- KMS encryption
- Lake Formation governance
- Secrets Manager for database credentials
- DynamoDB watermark table
- DynamoDB pipeline audit table
- Last successful timestamp incremental ingestion
- Data quality and rejected records
- Centralized logging and failure visibility

## Incremental Load Rule

The pipeline must extract data using the last successful timestamp.

The watermark must only be updated after the Iceberg MERGE succeeds.

## Environments

- dev

## Deployment Model

Feature branch
→ Pull Request
→ Terraform plan
→ Review
→ Merge to main
→ Terraform apply