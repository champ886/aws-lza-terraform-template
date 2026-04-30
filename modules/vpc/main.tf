# -----------------------------------------------
# PROVIDER REQUIREMENTS
# Provider is passed in from calling environment
# -----------------------------------------------
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# -----------------------------------------------
# VPC
# -----------------------------------------------
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.environment}-${var.account_name}-vpc"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# -----------------------------------------------
# INTERNET GATEWAY
# -----------------------------------------------
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.environment}-${var.account_name}-igw"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# -----------------------------------------------
# PUBLIC SUBNETS
# One per availability zone
# -----------------------------------------------
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.environment}-${var.account_name}-public-subnet-${count.index + 1}"
    Environment = var.environment
    Type        = "Public"
    ManagedBy   = "Terraform"
  }
}

# -----------------------------------------------
# PRIVATE SUBNETS
# One per availability zone
# -----------------------------------------------
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name        = "${var.environment}-${var.account_name}-private-subnet-${count.index + 1}"
    Environment = var.environment
    Type        = "Private"
    ManagedBy   = "Terraform"
  }
}

# -----------------------------------------------
# PUBLIC ROUTE TABLE
# -----------------------------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name        = "${var.environment}-${var.account_name}-public-rt"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# -----------------------------------------------
# PRIVATE ROUTE TABLES - ONE PER AZ
# Separate tables enable intra-AZ peering routing
# -----------------------------------------------
resource "aws_route_table" "private" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.environment}-${var.account_name}-private-rt-${count.index + 1}"
    Environment = var.environment
    AZ          = var.availability_zones[count.index]
    ManagedBy   = "Terraform"
  }
}

# -----------------------------------------------
# PUBLIC ROUTE TABLE ASSOCIATIONS
# -----------------------------------------------
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# -----------------------------------------------
# PRIVATE ROUTE TABLE ASSOCIATIONS
# Each subnet gets its own AZ route table
# -----------------------------------------------
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
