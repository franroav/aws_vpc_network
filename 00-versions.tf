
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.74.2"
    }
  }
}

provider "aws" {
  # aws configure sso/default/json/system-admin.
  # Session Token obtained from sts:GetSessionToken or sts:AssumeRole When MFA is configured.
  # aws sts get-session-token
  # aws
  region     = local.aws_region
  alias      = "us-east-1"
  profile    = local.aws_profile
  access_key = local.access_key
  secret_key = local.secret_key
  token      = local.token
}
locals {
  extra_tag = "extra-tag"
}



