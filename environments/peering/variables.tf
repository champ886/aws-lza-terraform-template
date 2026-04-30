variable "aws_region" {
  type    = string
  default = "YOUR_REGION"
}

variable "dev_workload_account_id" {
  description = "Dev workload account ID"
  type        = string
}

variable "prod_workload_account_id" {
  description = "Prod workload account ID"
  type        = string
}

variable "security_account_id" {
  description = "Shared security account ID"
  type        = string
}

variable "dev_workload_vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "prod_workload_vpc_cidr" {
  type    = string
  default = "10.2.0.0/16"
}

variable "security_vpc_cidr" {
  type    = string
  default = "10.1.0.0/16"
}
