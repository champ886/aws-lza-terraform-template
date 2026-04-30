variable "aws_region" {
  description = "AWS region — both VPCs must be in the same region"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "peering_name" {
  description = "Descriptive name e.g. dev-to-security"
  type        = string
}

variable "requester_vpc_id" {
  description = "VPC ID of the requester workload VPC"
  type        = string
}

variable "requester_vpc_cidr" {
  description = "CIDR block of the requester workload VPC"
  type        = string
}

variable "requester_route_table_az_a_id" {
  description = "Private route table ID for AZ-a in requester VPC"
  type        = string
}

variable "requester_route_table_az_b_id" {
  description = "Private route table ID for AZ-b in requester VPC"
  type        = string
}

variable "accepter_account_id" {
  description = "AWS account ID of the accepter security account"
  type        = string
}

variable "accepter_vpc_id" {
  description = "VPC ID of the accepter security VPC"
  type        = string
}

variable "accepter_vpc_cidr" {
  description = "CIDR block of the accepter security VPC"
  type        = string
}

variable "accepter_route_table_az_a_id" {
  description = "Private route table ID for AZ-a in accepter VPC"
  type        = string
}

variable "accepter_route_table_az_b_id" {
  description = "Private route table ID for AZ-b in accepter VPC"
  type        = string
}
