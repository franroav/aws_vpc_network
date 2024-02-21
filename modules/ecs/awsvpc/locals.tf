locals {

  ############################################################################
  # AWS Configuration                                                        #
  ############################################################################

  aws_account = data.aws_caller_identity.current.account_id # var.TF_VAR_AWS_ACCOUNT_ID
  aws_region  = "us-east-1"                                 #var.TF_VAR_AWS_REGION  # AWS region
  aws_profile = "system-admin"                              #var.TF_VAR_AWS_PROFILE # AWS profile
  alias       = "us-east-1"                                 #var.TF_VAR_AWS_REGION
  access_key  = var.TF_VAR_AWS_ACCESS_KEY_ID
  secret_key  = var.TF_VAR_AWS_SECRET_ACCESS_KEY
  token       = var.TF_VAR_AWS_SESSION_TOKEN

  /* -------------------------------------------------------------------------- */
  /*                            AWS ECR  - REGISTERY IMAGE                      */
  /* -------------------------------------------------------------------------- */


  ecr_reg   = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${local.aws_region}.amazonaws.com"
  image_tag = "latest" # Default image tag version

  #   dkr_img_src_path   = "${path.module}/containers" # Docker image path
  #   dkr_img_src_sha256 = sha256(join("", [for f in fileset(".", "${local.dkr_img_src_path}/**") : filebase64(f)]))

  /* -------------------------------------------------------------------------- */
  /*                            AWS ECR  - REPOSITORY && ROLE                   */
  /* -------------------------------------------------------------------------- */

  # Define a map for ECR repositories, ECR repo names
  ecr_repos = {
    frontend = "frontend-repo",
    api      = "api-repo",
    # webserver = "webserver-repo"
    # Add more services as needed
  }
}