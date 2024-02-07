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


variable "TF_VAR_VPC_CIDR" {
  description = "vpc cidr"
  type        = string
  sensitive   = true
}

variable "TF_VAR_PUBLIC_SUBNETS_CIDR" {
  description = "public subnets cidr"
  type        = list(string)
  sensitive   = true
}

variable "TF_VAR_PRIVATE_SUBNETS_CIDR" {
  description = "private subnets cidr"
  type        = list(string)
  sensitive   = true
}

variable "TF_VAR_AVAILABILITY_ZONES" {
  description = "List of availability zones"
  type        = list(string)
}


variable "TF_VAR_ENV" {
  description = "enviroment"
  type        = string
  sensitive   = true
}

variable "TF_VAR_NAME" {
  description = "vpc name"
  type        = string
  sensitive   = true
}

variable "TF_VAR_EC2_AMI" {
  description = "EC2 AMI"
  type        = string
  sensitive   = true
}

variable "TF_VAR_EC2_INSTANCE_TYPE" {
  description = "EC2 Instance Type"
  type        = string
  sensitive   = true
}

variable "TF_VAR_ENABLE_VPN_GATEWAY" {
  description = "enable vpn gateway"
  type        = bool
}

variable "TF_VAR_ENABLE_DNS_HOSTNAMES" {
  description = "enable dns hostnames"
  type        = bool
}

variable "TF_VAR_ENABLE_DNS_SUPPORT" {
  description = "enable dns support"
  type        = bool
}

variable "TF_VAR_TERRAFORM" {
  description = "terraform"
  type        = bool
  sensitive   = true
}

variable "TF_VAR_KEY_PAIR_NAMES" {
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
