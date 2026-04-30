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
# DEV WORKLOAD ACCOUNT
# Placed inside the Workload OU via parent_id
# -----------------------------------------------
resource "aws_organizations_account" "workload_dev" {
  name      = var.workload_dev_account_name
  email     = var.workload_dev_account_email
  role_name = "OrganizationAccountAccessRole"
  parent_id = var.workload_ou_id

  tags = {
    Environment = "dev"
    OU          = "Workload"
    ManagedBy   = "Terraform"
  }
}

# -----------------------------------------------
# PROD WORKLOAD ACCOUNT
# Separate account from dev to isolate blast radius
# -----------------------------------------------
resource "aws_organizations_account" "workload_prod" {
  name      = var.workload_prod_account_name
  email     = var.workload_prod_account_email
  role_name = "OrganizationAccountAccessRole"
  parent_id = var.workload_ou_id

  tags = {
    Environment = "prod"
    OU          = "Workload"
    ManagedBy   = "Terraform"
  }
}

# -----------------------------------------------
# SECURITY ACCOUNT
# Centralised security tooling account
# -----------------------------------------------
resource "aws_organizations_account" "security" {
  name      = var.security_account_name
  email     = var.security_account_email
  role_name = "OrganizationAccountAccessRole"
  parent_id = var.security_ou_id

  tags = {
    Environment = "all"
    OU          = "Security"
    ManagedBy   = "Terraform"
  }
}
