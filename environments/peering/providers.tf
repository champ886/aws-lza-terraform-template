provider "aws" {
  region = var.aws_region
}

provider "aws" {
  alias  = "dev_workload"
  region = var.aws_region

  assume_role {
    role_arn = "arn:aws:iam::${var.dev_workload_account_id}:role/OrganizationAccountAccessRole"
  }
}

provider "aws" {
  alias  = "prod_workload"
  region = var.aws_region

  assume_role {
    role_arn = "arn:aws:iam::${var.prod_workload_account_id}:role/OrganizationAccountAccessRole"
  }
}

provider "aws" {
  alias  = "security"
  region = var.aws_region

  assume_role {
    role_arn = "arn:aws:iam::${var.security_account_id}:role/OrganizationAccountAccessRole"
  }
}
