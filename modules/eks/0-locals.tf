

locals {
  # MAIN CONFIGURATION - ... (existing locals remain unchanged)
  aws_account = data.aws_caller_identity.current.account_id # var.TF_VAR_AWS_ACCOUNT_ID
  aws_region  = "us-east-1"                                 #var.TF_VAR_AWS_REGION  # AWS region
  aws_profile = "system-admin"                              #var.TF_VAR_AWS_PROFILE # AWS profile
  alias       = "us-east-1"                                 #var.TF_VAR_AWS_REGION
  access_key  = var.TF_VAR_AWS_ACCESS_KEY_ID
  secret_key  = var.TF_VAR_AWS_SECRET_ACCESS_KEY
  token       = var.TF_VAR_AWS_SESSION_TOKEN
  cluster_name = "karpenter-demo"

  # Used to determine correct partition (i.e. - `aws`, `aws-gov`, `aws-cn`, etc.)
  partition = data.aws_partition.current.partition


  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  name   = var.TF_VAR_CLUSTER_NAME
  region = var.TF_VAR_AWS_REGION

  vpc_cidr = var.TF_VAR_VPC_CIDR

  # azs      = var.TF_VAR_AVAILABILITY_ZONES

  public_subnets  = var.TF_VAR_PUBLIC_SUBNETS_CIDR
  private_subnets = var.TF_VAR_PRIVATE_SUBNETS_CIDR
  intra_subnets   = var.TF_VAR_INTRA_SUBNETS_CIDR


  # public_subnet_ids  = module.vpc.public_subnets_ids
  # private_subnet_ids = module.vpc.private_subnets_ids
  # intra_subnet_ids   = module.vpc.intra_subnets_ids

  tags = {
    Example = local.name
  }
}
