
variable "TF_VAR_TERRAFORM" {
  description = "terraform"
  type        = bool
  sensitive   = true
}

variable "TF_VAR_AWS_SESSION_TOKEN" {
  description = "aws sts get-session-token"
  type        = string
  sensitive   = true
}

variable "TF_VAR_AWS_SECRET_ACCESS_KEY" {
  description = "aws secret access key"
  type        = string
  sensitive   = true
}

variable "TF_VAR_AWS_ACCESS_KEY_ID" {
  description = "aws sts aws access key id"
  type        = string
  sensitive   = true
}

variable "TF_VAR_AWS_REGION" {
  description = "aws region"
  type        = string
  sensitive   = true
}

variable "TF_VAR_AWS_PROFILE" {
  description = "aws user account MFA profile"
  type        = string
  default     = "system-admin"
  # default = "${secrets.TF_VAR_AWS_PROFILE}"
  #   sensitive = true
}

variable "TF_VAR_AWS_ACCOUNT_ID" {
  description = "aws account id"
  type        = string
  # default = "${secrets.TF_VAR_AWS_ACCOUNT_ID}"
  #   sensitive = true
}


variable "TF_VAR_VPC_CIDR" {
  description = "vpc cidr"
  type        = string
  #   sensitive   = true
}

variable "TF_VAR_PUBLIC_SUBNETS_CIDR" {
  description = "vpc cidr"
  type        = list(string)
  #   sensitive   = true
}

variable "TF_VAR_PRIVATE_SUBNETS_CIDR" {
  description = "vpc cidr"
  type        = list(string)
  #   sensitive   = true
}

variable "TF_VAR_AVAILABILITY_ZONES" {
  description = "List of availability zones"
  type        = list(string)
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
