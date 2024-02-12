# ******************************************************* NETWORKING - VPC *****************************************************************

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.16.2"
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



