# -----------------------------------------------
# ENVIRONMENT
# -----------------------------------------------
variable "environment" {
  description = "Environment name"
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
# APPROVED REGIONS
# Any region not in this list will be blocked
# -----------------------------------------------
variable "approved_regions" {
  description = "List of approved AWS regions"
  type        = list(string)
  default     = ["YOUR_REGION"]
}
