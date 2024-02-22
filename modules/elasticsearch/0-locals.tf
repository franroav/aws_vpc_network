
/* -------------------------------------------------------------------------- */
/*                                   LOCALS                                   */
/* -------------------------------------------------------------------------- */

locals {
  # MAIN CONFIGURATION - ... (existing locals remain unchanged)
  aws_account = data.aws_caller_identity.current.account_id # var.TF_VAR_AWS_ACCOUNT_ID
  aws_region  = "us-east-1"  #var.TF_VAR_AWS_REGION  # AWS region
  aws_profile = "system-admin" #var.TF_VAR_AWS_PROFILE # AWS profile
  alias       = "us-east-1"  #var.TF_VAR_AWS_REGION
  access_key  = var.TF_VAR_AWS_ACCESS_KEY_ID
  secret_key  = var.TF_VAR_AWS_SECRET_ACCESS_KEY
  token       = var.TF_VAR_AWS_SESSION_TOKEN

}