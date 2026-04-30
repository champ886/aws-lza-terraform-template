terraform {
  backend "s3" {
    bucket         = "YOUR_STATE_BUCKET"
    key            = "aws-lza/peering/terraform.tfstate"
    region         = "YOUR_REGION"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
