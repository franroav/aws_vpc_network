
/* -------------------------------------------------------------------------- */
/*                                   MODULES                        */
/* -------------------------------------------------------------------------- */


module "networking" {
  source                      = "./modules/networking"
  TF_VAR_NAME                 = var.TF_VAR_NAME
  TF_VAR_AWS_REGION           = var.TF_VAR_AWS_REGION
  TF_VAR_ENABLE_DNS_SUPPORT   = var.TF_VAR_ENABLE_DNS_SUPPORT
  TF_VAR_ENABLE_VPN_GATEWAY   = var.TF_VAR_ENABLE_VPN_GATEWAY
  TF_VAR_VPC_CIDR                 = var.TF_VAR_VPC_CIDR
  TF_VAR_PUBLIC_SUBNETS_CIDR  = var.TF_VAR_PUBLIC_SUBNETS_CIDR
  TF_VAR_ENV                  = var.TF_VAR_ENV
  TF_VAR_AVAILABILITY_ZONES   = var.TF_VAR_AVAILABILITY_ZONES
  TF_VAR_PRIVATE_SUBNETS_CIDR = var.TF_VAR_PRIVATE_SUBNETS_CIDR
  TF_VAR_TERRAFORM            = var.TF_VAR_TERRAFORM
  TF_VAR_ENABLE_DNS_HOSTNAMES = var.TF_VAR_ENABLE_DNS_HOSTNAMES
  TF_VAR_KEY_PAIR_NAMES       = var.TF_VAR_KEY_PAIR_NAMES
  TF_VAR_AWS_ACCOUNT_ID       = var.TF_VAR_AWS_ACCOUNT_ID
  TF_VAR_EC2_AMI = var.TF_VAR_EC2_AMI
  TF_VAR_EC2_INSTANCE_TYPE = var.TF_VAR_EC2_INSTANCE_TYPE
  #   region               = var.TF_VAR_region
  #   environment          = "${var.TF_VAR_ENV}"
  #   vpc_cidr             = "${var.TF_VAR_VPC_CIDR}"
  #   public_subnets_cidr  = "${var.TF_VAR_PUBLIC_SUBNETS_CIDR}"
  #   private_subnets_cidr = "${var.TF_VAR_PRIVATE_SUBNETS_CIDR}"
  #   availability_zones   = "${local.TF_VAR_AVAILABILITY_ZONES}"
}



