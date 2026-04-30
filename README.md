# AWS Landing Zone Accelerator — Terraform

A production-ready AWS Landing Zone built with Terraform covering multi-account organisation structure, SCPs, VPC networking with peering, and isolated state management.

## Architecture

```
AWS Organization
├── Management account        — Config, CloudWatch, S3 archive, Terraform
├── Workload OU
│   ├── Dev account           — Dev VPC 10.0.0.0/16
│   └── Prod account          — Prod VPC 10.2.0.0/16
└── Security OU
    └── Security account      — Shared VPC 10.1.0.0/16, GuardDuty, Security Hub
```

VPC peering connects dev and prod workload VPCs to the shared security VPC using per-AZ route tables for intra-AZ routing.

## Prerequisites

- Terraform >= 1.5.0
- AWS CLI configured with management account credentials
- S3 bucket and DynamoDB table for Terraform state
- AWS Organization (or create one via this code)

## Deployment order

```bash
# 1. Foundation
cd environments/management
terraform init && terraform apply -var-file="terraform.tfvars"

# 2. Shared security VPC
cd environments/shared/vpc
terraform init && terraform apply -var-file="terraform.tfvars"

# 3. Dev VPC
cd environments/dev/vpc
terraform init && terraform apply -var-file="terraform.tfvars"

# 4. Prod VPC
cd environments/prod/vpc
terraform init && terraform apply -var-file="terraform.tfvars"

# 5. VPC peering
cd environments/peering
terraform init && terraform apply -var-file="terraform.tfvars"
```

## Configuration

Copy and fill in each `terraform.tfvars.example` file:

```bash
cp environments/management/terraform.tfvars.example environments/management/terraform.tfvars
# repeat for each environment
```

## Variables to replace

| Variable | Description |
|---|---|
| `YOUR_ORG_ID` | AWS Organization ID e.g. o-xxxxxxxxxx |
| `YOUR_MGMT_ACCOUNT_ID` | Management account ID |
| `YOUR_DEV_ACCOUNT_EMAIL` | Unique email for dev workload account |
| `YOUR_PROD_ACCOUNT_EMAIL` | Unique email for prod workload account |
| `YOUR_SECURITY_ACCOUNT_EMAIL` | Unique email for security account |
| `YOUR_STATE_BUCKET` | S3 bucket name for Terraform state |
| `YOUR_REGION` | AWS region e.g. ap-southeast-2 |

## SCPs applied

- Deny root account access
- Deny leaving the organization
- Deny disabling CloudTrail or AWS Config
- Deny SCP modifications
- Deny non-approved regions
- Deny disabling GuardDuty or Security Hub

## State management

Each environment has an isolated state file:

```
YOUR_STATE_BUCKET/
  aws-lza/management/terraform.tfstate
  aws-lza/shared/vpc/terraform.tfstate
  aws-lza/dev/vpc/terraform.tfstate
  aws-lza/prod/vpc/terraform.tfstate
  aws-lza/peering/terraform.tfstate
```

## .gitignore

Sensitive files are excluded — never commit `terraform.tfvars` files as they contain account IDs and emails.
