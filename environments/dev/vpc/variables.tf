variable "aws_region" {
  type    = string
  default = "YOUR_REGION"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "workload_account_id" {
  description = "Dev workload account ID"
  type        = string
}

variable "workload_vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "workload_public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "workload_private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
  type    = list(string)
  default = ["YOUR_REGION_AZ_A", "YOUR_REGION_AZ_B"]
}
