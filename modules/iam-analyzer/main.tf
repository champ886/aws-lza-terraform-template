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
# IAM ACCESS ANALYZER
# Free service — no trial period
# Scans resource policies across the entire org
# and raises findings for anything accessible
# from outside your AWS Organization
# Covers: S3, IAM roles, KMS, Lambda, SQS, Secrets
# -----------------------------------------------
resource "aws_accessanalyzer_analyzer" "main" {
  analyzer_name = "${var.environment}-access-analyzer"
  type          = var.analyzer_type

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
