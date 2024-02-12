variable "TF_VAR_AWS_SESSION_TOKEN" {
  description = "aws sts get-session-token"
  type        = string
}

variable "TF_VAR_AWS_SECRET_ACCESS_KEY" {
  description = "aws secret access key"
  type        = string
}

variable "TF_VAR_AWS_ACCESS_KEY_ID" {
  description = "aws sts aws access key id"
  type        = string
}


variable "a_records" {
  type = list(string)
}

variable "app_asg_max" {
  type = number
}

variable "app_asg_min" {
  type = number
}

variable "app_port" {
  type = number
}

variable "https_port" {
  type = number
}

variable "db_port" {
  type = number
}

variable "ssh_port" {
  type = number
}

variable "http_port" {
  type = number
}
# variable "app_subnets" {
#   type = list(string)
#   default = ["subnet-a", "subnet-b"]  # Replace with your actual subnet IDs
# }
# variable "app_subnets" {
#   type    = map(any)
#   default = {
#     a = "subnet-xxxxxx"
#     b = "subnet-yyyyyy"
#     # Add more subnets as needed
#   }
# }
variable "app_subnets" {
  type = map(any)
}

variable "bucket_name" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "db_subnets" {
  type = map(any)
}

variable "root_domain_name" {
  type = string
}

variable "dns_zone" {
  type = string
}

variable "domains" {
  type = list(string)
}

variable "hosted_zone" {
  type = string
}

variable "image_id" {
  type = string
}

variable "ipset_value" {
  type = string
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
}

variable "web_asg_max" {
  type = number
}

variable "web_asg_min" {
  type = number
}

variable "web_subnets" {
  type = map(any)
}

variable "domain_name" {
  type = string
}


