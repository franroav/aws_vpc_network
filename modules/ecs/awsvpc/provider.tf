# ******************************************************* NETWORKING - VPC *****************************************************************

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.16.2"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 2.13.0" # Specify a version compatible with your Terraform version
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
}

provider "docker" {
  alias = "hashicorp"
  registry_auth {
    address  = local.ecr_reg
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password
  }
  # source = "kreuzwerker/docker"
}

# terraform {

#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 4.15.0"
#     }

#     random = {
#       source  = "hashicorp/random"
#       version = "3.1.0"
#     }
#     kubernetes = {
#       source  = "hashicorp/kubernetes"
#       version = ">= 2.0.1"
#     }
#   }

# backend "remote" {
# 		hostname = "app.terraform.io"
# 		organization = "CloudQuickLabs"

# 		workspaces {
# 			name = "AWSECS"
# 		}
# 	}
# }

# provider "aws" {
#   region     = local.aws_region
#   alias      = "us-east-1"
#   profile    = local.aws_profile
#   access_key = local.access_key
#   secret_key = local.secret_key
#   token      = local.token
# }