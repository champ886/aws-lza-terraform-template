# -----------------------------------------------
# ORGANIZATION MODULE
# -----------------------------------------------
module "organization" {
  source = "../../modules/organization"
}

# -----------------------------------------------
# ACCOUNTS MODULE
# -----------------------------------------------
module "accounts" {
  source                      = "../../modules/accounts"
  environment                 = var.environment
  org_id                      = var.org_id
  workload_ou_id              = module.organization.workload_ou_id
  security_ou_id              = module.organization.security_ou_id
  workload_dev_account_name   = var.workload_dev_account_name
  workload_dev_account_email  = var.workload_dev_account_email
  workload_prod_account_name  = var.workload_prod_account_name
  workload_prod_account_email = var.workload_prod_account_email
  security_account_name       = var.security_account_name
  security_account_email      = var.security_account_email

  depends_on = [module.organization]
}

# -----------------------------------------------
# CONFIG MODULE
# -----------------------------------------------
module "config" {
  source      = "../../modules/config"
  environment = var.environment

  depends_on = [module.organization]
}

# -----------------------------------------------
# LOGGING MODULE
# -----------------------------------------------
module "logging" {
  source             = "../../modules/logging"
  environment        = var.environment
  log_retention_days = var.log_retention_days
}

# -----------------------------------------------
# SCP MODULE
# -----------------------------------------------
module "scp" {
  source           = "../../modules/scp"
  environment      = var.environment
  workload_ou_id   = module.organization.workload_ou_id
  security_ou_id   = module.organization.security_ou_id
  approved_regions = var.approved_regions

  depends_on = [module.organization]
}

# -----------------------------------------------
# IAM ACCESS ANALYZER MODULE
# Free — scans all accounts in the org for
# overly permissive resource policies
# Requires access-analyzer.amazonaws.com enabled
# in aws_service_access_principals in org module
# -----------------------------------------------
module "iam_analyzer" {
  source        = "../../modules/iam-analyzer"
  environment   = var.environment
  analyzer_type = var.analyzer_type

  depends_on = [module.organization]
}
