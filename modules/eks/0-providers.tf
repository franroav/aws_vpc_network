
terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      version = ">= 4.34.0"
      source  = "hashicorp/aws"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.16.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }
    kustomization = {
      source  = "kbst/kustomization"
      version = "0.9.0"
    }
  }
}

provider "aws" {
  region     = local.aws_region
  alias      = "us-east-1"
  profile    = local.aws_profile
  access_key = local.access_key
  secret_key = local.secret_key
  token      = local.token
  # shared_credentials_files = ["/Users/franr/.aws/credentials"] 
}



