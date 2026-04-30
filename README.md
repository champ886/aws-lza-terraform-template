# AWS Landing Zone Accelerator — Terraform

A production-ready AWS Landing Zone built with Terraform covering multi-account organisation structure, SCPs, VPC networking with peering, isolated state management, and continuous IAM policy analysis.

## Architecture

```
AWS Organization
├── Management account        — Config, CloudWatch, S3 archive, Terraform
│                               IAM Access Analyzer (org-wide, free)
├── Workload OU
│   ├── Dev account           — Dev VPC 10.0.0.0/16 · per-AZ route tables
│   └── Prod account          — Prod VPC 10.2.0.0/16 · per-AZ route tables
└── Security OU
    └── Security account      — Shared VPC 10.1.0.0/16
                                Accepts VPC peering from dev + prod
```

VPC peering connects dev and prod workload VPCs to the shared security VPC using per-AZ route tables for intra-AZ routing and zero cross-AZ data transfer costs.

## What is deployed

| Resource | Account | Cost |
|---|---|---|
| AWS Organizations + OUs | Management | Free |
| Service Control Policies (3) | Management | Free |
| AWS Config recorder | Management | ~$2-5/month |
| CloudWatch log group | Management | ~$0.50-2/month |
| S3 log archive bucket | Management | ~$0.01/month |
| IAM Access Analyzer | Management | Free |
| Dev VPC + subnets | Dev workload | Free |
| Prod VPC + subnets | Prod workload | Free |
| Shared security VPC + subnets | Security | Free |
| VPC peering x2 | Cross-account | Free |

**Estimated total: ~$3-8/month**

## IAM Access Analyzer

Deployed as `type = ORGANIZATION` from the management account. Continuously scans resource policies across all accounts and raises findings for anything accessible from outside your AWS Organization. Covers S3 buckets, IAM roles, KMS keys, Lambda functions, SQS queues and Secrets Manager secrets. No trial period — permanently free.

To view findings: AWS Console > IAM > Access Analyzer

## SCPs applied

- Deny root account access
- Deny leaving the organization
- Deny disabling CloudTrail or AWS Config
- Deny SCP modifications
- Deny non-approved regions
- Deny disabling GuardDuty or Security Hub (future-proofed)
- FullAWSAccess attached to all OUs as baseline

## VPC CIDR design

| VPC | Account | CIDR |
|---|---|---|
| Dev VPC | Dev workload | 10.0.0.0/16 |
| Shared security VPC | Security | 10.1.0.0/16 |
| Prod VPC | Prod workload | 10.2.0.0/16 |

Non-overlapping ranges allow future VPC peering between any combination.

## Prerequisites

- Terraform >= 1.5.0
- AWS CLI configured with management account credentials
- S3 bucket and DynamoDB table for Terraform state
- AWS Organization (or create one via this code)

## Quick start

```bash
# 1. Clone the repo
git clone https://github.com/YOUR_USERNAME/aws-lza-terraform.git
cd aws-lza-terraform

# 2. Copy and fill in each tfvars file
cp environments/management/terraform.tfvars.example environments/management/terraform.tfvars
cp environments/shared/vpc/terraform.tfvars.example environments/shared/vpc/terraform.tfvars
cp environments/dev/vpc/terraform.tfvars.example environments/dev/vpc/terraform.tfvars
cp environments/prod/vpc/terraform.tfvars.example environments/prod/vpc/terraform.tfvars
cp environments/peering/terraform.tfvars.example environments/peering/terraform.tfvars

# 3. Deploy in order
cd environments/management && terraform init && terraform apply -var-file="terraform.tfvars"
cd ../shared/vpc && terraform init && terraform apply -var-file="terraform.tfvars"
cd ../../dev/vpc && terraform init && terraform apply -var-file="terraform.tfvars"
cd ../../prod/vpc && terraform init && terraform apply -var-file="terraform.tfvars"
cd ../../peering && terraform init && terraform apply -var-file="terraform.tfvars"
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
| `YOUR_REGION_AZ_A` | First AZ e.g. ap-southeast-2a |
| `YOUR_REGION_AZ_B` | Second AZ e.g. ap-southeast-2b |

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

## Directory structure

```
environments/
  management/       — org, accounts, SCPs, Config, logging, IAM analyzer
  shared/vpc/       — shared security VPC deployed once
  dev/vpc/          — dev workload VPC
  prod/vpc/         — prod workload VPC
  peering/          — VPC peering dev to security and prod to security

modules/
  organization/     — AWS Org, OUs, service principals
  accounts/         — member account creation
  scp/              — service control policies
  config/           — AWS Config recorder and IAM role
  logging/          — CloudWatch and S3 log archive
  vpc/              — VPC, subnets, route tables, IGW
  vpc-peering/      — peering connection, routes, DNS options
  iam-analyzer/     — IAM Access Analyzer
```

## .gitignore

Never commit terraform.tfvars files as they contain account IDs and emails. Use the .example files as templates.
