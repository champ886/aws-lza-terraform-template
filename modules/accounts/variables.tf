# -----------------------------------------------
# ENVIRONMENT
# -----------------------------------------------
variable "environment" {
  description = "Environment name"
  type        = string
}

# -----------------------------------------------
# ORGANIZATION ID
# -----------------------------------------------
variable "org_id" {
  description = "AWS Organization ID"
  type        = string
}

# -----------------------------------------------
# OU IDS
# -----------------------------------------------
variable "workload_ou_id" {
  description = "ID of the Workload OU"
  type        = string
}

variable "security_ou_id" {
  description = "ID of the Security OU"
  type        = string
}

# -----------------------------------------------
# DEV WORKLOAD ACCOUNT
# Email must be globally unique across all AWS accounts
# -----------------------------------------------
variable "workload_dev_account_name" {
  description = "Name of the workload dev account"
  type        = string
}

variable "workload_dev_account_email" {
  description = "Email for the workload dev account"
  type        = string
}

# -----------------------------------------------
# PROD WORKLOAD ACCOUNT
# Must use a different email from dev account
# -----------------------------------------------
variable "workload_prod_account_name" {
  description = "Name of the workload prod account"
  type        = string
}

variable "workload_prod_account_email" {
  description = "Email for the workload prod account"
  type        = string
}

# -----------------------------------------------
# SECURITY ACCOUNT
# -----------------------------------------------
variable "security_account_name" {
  description = "Name of the security account"
  type        = string
}

variable "security_account_email" {
  description = "Email for the security account"
  type        = string
}
