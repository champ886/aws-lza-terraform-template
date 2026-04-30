# -----------------------------------------------
# PROVIDER REQUIREMENTS
# Peering spans two accounts — needs both providers
# -----------------------------------------------
terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws.requester, aws.accepter]
    }
  }
}

# -----------------------------------------------
# VPC PEERING CONNECTION REQUEST
# Initiated from requester (workload) account
# -----------------------------------------------
resource "aws_vpc_peering_connection" "main" {
  provider      = aws.requester
  vpc_id        = var.requester_vpc_id
  peer_vpc_id   = var.accepter_vpc_id
  peer_owner_id = var.accepter_account_id
  peer_region   = var.aws_region
  auto_accept   = false

  tags = {
    Name        = "${var.environment}-${var.peering_name}-peering"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# -----------------------------------------------
# VPC PEERING CONNECTION ACCEPTER
# Auto-accepts from accepter (security) account
# Safe as both accounts are in the same org
# -----------------------------------------------
resource "aws_vpc_peering_connection_accepter" "main" {
  provider                  = aws.accepter
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id
  auto_accept               = true

  tags = {
    Name        = "${var.environment}-${var.peering_name}-peering"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# -----------------------------------------------
# PEERING OPTIONS - REQUESTER
# Enables DNS resolution across peering link
# -----------------------------------------------
resource "aws_vpc_peering_connection_options" "requester" {
  provider                  = aws.requester
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.main.id

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  depends_on = [aws_vpc_peering_connection_accepter.main]
}

# -----------------------------------------------
# PEERING OPTIONS - ACCEPTER
# -----------------------------------------------
resource "aws_vpc_peering_connection_options" "accepter" {
  provider                  = aws.accepter
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.main.id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  depends_on = [aws_vpc_peering_connection_accepter.main]
}

# -----------------------------------------------
# REQUESTER ROUTES - PER AZ
# Keeps traffic intra-AZ across peering
# -----------------------------------------------
resource "aws_route" "requester_to_accepter_az_a" {
  provider                  = aws.requester
  route_table_id            = var.requester_route_table_az_a_id
  destination_cidr_block    = var.accepter_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id

  depends_on = [aws_vpc_peering_connection_accepter.main]
}

resource "aws_route" "requester_to_accepter_az_b" {
  provider                  = aws.requester
  route_table_id            = var.requester_route_table_az_b_id
  destination_cidr_block    = var.accepter_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id

  depends_on = [aws_vpc_peering_connection_accepter.main]
}

# -----------------------------------------------
# ACCEPTER ROUTES - PER AZ
# -----------------------------------------------
resource "aws_route" "accepter_to_requester_az_a" {
  provider                  = aws.accepter
  route_table_id            = var.accepter_route_table_az_a_id
  destination_cidr_block    = var.requester_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id

  depends_on = [aws_vpc_peering_connection_accepter.main]
}

resource "aws_route" "accepter_to_requester_az_b" {
  provider                  = aws.accepter
  route_table_id            = var.accepter_route_table_az_b_id
  destination_cidr_block    = var.requester_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id

  depends_on = [aws_vpc_peering_connection_accepter.main]
}
