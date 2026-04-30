variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "YOUR_REGION"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "management"
}

variable "org_id" {
  description = "AWS Organization ID"
  type        = string
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 90
}

variable "approved_regions" {
  description = "List of approved AWS regions"
  type        = list(string)
  default     = ["YOUR_REGION"]
}

variable "workload_dev_account_name" {
  description = "Name of the workload dev account"
  type        = string
}

variable "workload_dev_account_email" {
  description = "Email for the workload dev account"
  type        = string
}

variable "workload_prod_account_name" {
  description = "Name of the workload prod account"
  type        = string
}

variable "workload_prod_account_email" {
  description = "Email for the workload prod account"
  type        = string
}

variable "security_account_name" {
  description = "Name of the security account"
  type        = string
}

variable "security_account_email" {
  description = "Email for the security account"
  type        = string
}
