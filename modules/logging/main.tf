# -----------------------------------------------
# PROVIDER REQUIREMENTS
# -----------------------------------------------
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# -----------------------------------------------
# CLOUDWATCH LOG GROUP
# -----------------------------------------------
resource "aws_cloudwatch_log_group" "main" {
  name              = "/aws/${var.environment}/lza-logs"
  retention_in_days = var.log_retention_days

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# -----------------------------------------------
# S3 LOG ARCHIVE BUCKET
# -----------------------------------------------
resource "aws_s3_bucket" "log_archive" {
  bucket = "${var.environment}-lza-log-archive-${data.aws_caller_identity.current.account_id}"

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# -----------------------------------------------
# S3 BUCKET VERSIONING
# -----------------------------------------------
resource "aws_s3_bucket_versioning" "log_archive" {
  bucket = aws_s3_bucket.log_archive.id
  versioning_configuration {
    status = "Enabled"
  }
}

# -----------------------------------------------
# CURRENT ACCOUNT DATA SOURCE
# -----------------------------------------------
data "aws_caller_identity" "current" {}
