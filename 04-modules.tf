
/* -------------------------------------------------------------------------- */
/*                                   MODULES                        */
/* -------------------------------------------------------------------------- */


module "networking" {
  source                      = "./modules/networking"
  TF_VAR_name                 = var.TF_VAR_name
  TF_VAR_AWS_REGION           = var.TF_VAR_AWS_REGION
  TF_VAR_enable_dns_support   = var.TF_VAR_enable_dns_support
  TF_VAR_enable_vpn_gateway   = var.TF_VAR_enable_vpn_gateway
  TF_VAR_vpc_cidr                 = var.TF_VAR_vpc_cidr
  TF_VAR_public_subnets_cidr  = var.TF_VAR_public_subnets_cidr
  TF_VAR_env                  = var.TF_VAR_env
  TF_VAR_availability_zones   = var.TF_VAR_availability_zones
  TF_VAR_private_subnets_cidr = var.TF_VAR_private_subnets_cidr
  TF_VAR_terraform            = var.TF_VAR_terraform
  TF_VAR_enable_dns_hostnames = var.TF_VAR_enable_dns_hostnames
  TF_VAR_key_pair_names       = var.TF_VAR_key_pair_names
  TF_VAR_AWS_ACCOUNT_ID       = var.TF_VAR_AWS_ACCOUNT_ID
  TF_VAR_ec2_ami = var.TF_VAR_ec2_ami
  TF_VAR_ec2_instance_type = var.TF_VAR_ec2_instance_type
  #   region               = var.TF_VAR_region
  #   environment          = "${var.TF_VAR_env}"
  #   vpc_cidr             = "${var.TF_VAR_vpc_cidr}"
  #   public_subnets_cidr  = "${var.TF_VAR_public_subnets_cidr}"
  #   private_subnets_cidr = "${var.TF_VAR_private_subnets_cidr}"
  #   availability_zones   = "${local.TF_VAR_availability_zones}"
}



