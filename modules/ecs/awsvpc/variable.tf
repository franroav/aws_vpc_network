############################################################################
# AWS Configuration                                                        #
############################################################################
variable "TF_VAR_AWS_PROFILE" {
  description = "aws user account MFA profile"
  type        = string
  default     = "system-admin"
  # default = "${secrets.TF_VAR_AWS_PROFILE}"
  #   sensitive = true
}

variable "TF_VAR_AWS_REGION" {
  description = "aws account region"
  type        = string
  default     = "us-east-1"
  # default = "${secrets.TF_VAR_AWS_REGION}"
  #   sensitive = true
}

variable "TF_VAR_AWS_ACCOUNT_ID" {
  description = "aws account id"
  type        = string
  default     = 921283598378
  # default = "${secrets.TF_VAR_AWS_ACCOUNT_ID}"
  #   sensitive = true
}

variable "TF_VAR_AWS_SESSION_TOKEN" {
  description = "aws sts get-session-token"
  type        = string
  # default = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  # default = "${secrets.TF_VAR_AWS_SESSION_TOKEN}"
  #   sensitive = true
}

variable "TF_VAR_AWS_SECRET_ACCESS_KEY" {
  description = "aws secret access key"
  type        = string
  # default = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  # default = "${secrets.TF_VAR_AWS_SECRET_ACCESS_KEY}"
  #   sensitive = true
}

variable "TF_VAR_AWS_ACCESS_KEY_ID" {
  description = "aws sts aws access key id"
  type        = string
  # default = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  # default = "${secrets.TF_VAR_AWS_ACCESS_KEY_ID}"
  #   sensitive = true
}

############################################################################
# AWS NETWORK Configuration                                                #
############################################################################

variable "vpc_name" {
  description = "Name of VPC"
  default     = "test_vpc"
}

variable "vpc_cidr" {
  description = "VPC cidr block"
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

# variable "private_subnets" {
#   type    = list(string)
#   default = ["10.0.2.0/24", "10.0.3.0/24"]
# }

# variable "public_subnets" {
#   type    = list(string)
#   default = ["10.0.0.0/24", "10.0.1.0/24"]
# }

# variable "database_subnets" {
#   type    = list(string)
#   default = ["10.0.4.0/24", "10.0.5.0/24"]
# }

# variable "vpc_id" {}

variable "vpc_id_subnet_list" {
  type    = list(string)
  default = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
}

############################################################################
# ENVIROMENT CONFIGURATION                                                  #
############################################################################

variable "TF_VAR_env" {
  description = "environment"
  type        = string
  default     = "production"
  #   sensitive   = true
}

############################################################################
# AWS ECS CLUSTER Configuration                                                #
############################################################################

variable "cluster_name" {
  description = "cluster name"
  type        = string
  default     = "demo-api-cluster"
}

variable "ecs_cluster_names" {
  type = map(string)
  default = {
    public = "demo-api-cluster"
    # appserver = "appserver-cluster"
    # dbserver  = "dbserver-cluster"
  }
}

variable "cluster_service_name" {
  description = "service name"
  type        = string
  default     = "cloud-api-service"
}

variable "cluster_service_task_name" {
  description = "task name"
  type        = string
  default     = "cloud-api-task"
}

############################################################################
# AWS IMAGE Configuration                                                #
############################################################################

variable "image_id" {
  description = "task name"
  type        = string
  default     = "cloud-api-task"
}

# variable "execution_role_arn" {}


