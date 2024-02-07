variable "TF_VAR_AWS_REGION" {
  description = "aws region"
  type = string
  sensitive = true
}

variable "TF_VAR_AWS_PROFILE" {
description = "aws user account MFA profile"
  type = string
  default = "system-admin"
  # default = "${secrets.TF_VAR_AWS_PROFILE}"
  #   sensitive = true
}

variable "TF_VAR_AWS_ACCOUNT_ID" {
description = "aws account id"
  type = string
  # default = "${secrets.TF_VAR_AWS_ACCOUNT_ID}"
#   sensitive = true
}


variable "TF_VAR_vpc_cidr" {
  description = "vpc cidr"
  type        = string
  sensitive   = true
}

variable "TF_VAR_public_subnets_cidr" {
  description = "public subnets cidr"
  type        = list(string)
  sensitive   = true
}

variable "TF_VAR_private_subnets_cidr" {
  description = "private subnets cidr"
  type        = list(string)
  sensitive   = true
}

variable "TF_VAR_availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}


variable "TF_VAR_env" {
  description = "enviroment"
  type        = string
  sensitive   = true
}

variable "TF_VAR_name" {
  description = "vpc name"
  type        = string
  sensitive   = true
}

variable "TF_VAR_ec2_ami" {
  description = "EC2 AMI"
  type        = string
  sensitive   = true
}

variable "TF_VAR_ec2_instance_type" {
  description = "EC2 Instance Type"
  type        = string
  sensitive   = true
}

variable "TF_VAR_enable_vpn_gateway" {
  description = "enable vpn gateway"
  type        = bool
}

variable "TF_VAR_enable_dns_hostnames" {
  description = "enable dns hostnames"
  type        = bool
}

variable "TF_VAR_enable_dns_support" {
  description = "enable dns support"
  type        = bool
}

variable "TF_VAR_terraform" {
  description = "terraform"
  type        = bool
  sensitive   = true
}

variable "TF_VAR_key_pair_names" {
  description = "Map of key pair names"
  type        = map(string)
  # Optionally, you can set default values here if needed.
  # default     = {
  #   "Public-Instance-0"  = "my_key_pair",
  #   "Public-Instance-1"  = "my_key_pair",
  #   "Private-Instance-0" = "my_key_pair",
  #   "Private-Instance-1" = "my_key_pair",
  # }
}
