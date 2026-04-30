# -----------------------------------------------
# ENVIRONMENT
# -----------------------------------------------
variable "environment" {
  description = "Environment name"
  type        = string
}

# -----------------------------------------------
# ANALYZER TYPE
# ACCOUNT — scans resources in a single account
# ORGANIZATION — scans across all accounts in org
# Must run from the management account
# -----------------------------------------------
variable "analyzer_type" {
  description = "Type of analyzer — ACCOUNT or ORGANIZATION"
  type        = string
  default     = "ORGANIZATION"
}
