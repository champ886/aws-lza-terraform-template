variable "aws_region" {
  type    = string
  default = "YOUR_REGION"
}

variable "environment" {
  type    = string
  default = "shared"
}

variable "security_account_id" {
  description = "Security account ID"
  type        = string
}

variable "security_vpc_cidr" {
  type    = string
  default = "10.1.0.0/16"
}

variable "security_public_subnet_cidrs" {
  type    = list(string)
  default = ["10.1.1.0/24", "10.1.2.0/24"]
}

variable "security_private_subnet_cidrs" {
  type    = list(string)
  default = ["10.1.3.0/24", "10.1.4.0/24"]
}

variable "availability_zones" {
  type    = list(string)
  default = ["YOUR_REGION_AZ_A", "YOUR_REGION_AZ_B"]
}
