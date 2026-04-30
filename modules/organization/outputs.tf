# -----------------------------------------------
# WORKLOAD OU ID
# -----------------------------------------------
output "workload_ou_id" {
  description = "ID of the Workload OU"
  value       = aws_organizations_organizational_unit.workload.id
}

# -----------------------------------------------
# SECURITY OU ID
# -----------------------------------------------
output "security_ou_id" {
  description = "ID of the Security OU"
  value       = aws_organizations_organizational_unit.security.id
}

# -----------------------------------------------
# ORGANIZATION ID
# -----------------------------------------------
output "organization_id" {
  description = "ID of the Organization"
  value       = aws_organizations_organization.main.id
}

# -----------------------------------------------
# ROOT ID
# -----------------------------------------------
output "root_id" {
  description = "ID of the Organization root"
  value       = aws_organizations_organization.main.roots[0].id
}
