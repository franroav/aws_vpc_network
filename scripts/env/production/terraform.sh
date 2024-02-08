#!/bin/bash

set -e

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Navigate to the root directory of the project
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

# Check if .env file exists in the root directory
if [ -f "$ROOT_DIR/.env" ]; then
    # If the .env file exists, load the variables
    source "$ROOT_DIR/.env"
else
    # If .env file doesn't exist, print an error message and exit
    echo "Error: .env file not found in the root directory."
    exit 1
fi

# Install necessary dependencies
sudo apt-get update
sudo apt-get install -y curl unzip

# Install Terraform
TERRAFORM_VERSION="1.1.0"
TERRAFORM_URL="https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
curl -LO $TERRAFORM_URL
unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
sudo mv terraform /usr/local/bin/
rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Initialize Terraform
terraform init

# Validate Terraform configuration
terraform validate

# Plan Terraform changes
# terraform plan \
#   -var "TF_VAR_NAME=$TF_VAR_NAME" \
#   -var "TF_VAR_ENV=$TF_VAR_ENV" \
#   -var "TF_VAR_VPC_CIDR=$TF_VAR_VPC_CIDR" \
#   -var "TF_VAR_PUBLIC_SUBNETS_CIDR=$TF_VAR_PUBLIC_SUBNETS_CIDR" \
#   -var "TF_VAR_PRIVATE_SUBNETS_CIDR=$TF_VAR_PRIVATE_SUBNETS_CIDR" \
#   -var "TF_VAR_AVAILABILITY_ZONES=$TF_VAR_AVAILABILITY_ZONES" \
#   -var "TF_VAR_EC2_AMI=$TF_VAR_EC2_AMI" \
#   -var "TF_VAR_EC2_INSTANCE_TYPE=$TF_VAR_EC2_INSTANCE_TYPE" \
#   -var "TF_VAR_AWS_ACCESS_KEY_ID=$TF_VAR_AWS_ACCESS_KEY_ID" \
#   -var "TF_VAR_AWS_SECRET_ACCESS_KEY=$TF_VAR_AWS_SECRET_ACCESS_KEY" \
#   -var "TF_VAR_AWS_SESSION_TOKEN=$TF_VAR_AWS_SESSION_TOKEN" \
#   -var "TF_VAR_AWS_ACCOUNT_ID=$TF_VAR_AWS_ACCOUNT_ID" \
#   -var "TF_VAR_AWS_REGION=$TF_VAR_AWS_REGION" \
#   -var "TF_VAR_AWS_PROFILE=$TF_VAR_AWS_PROFILE" \
#   -var "TF_VAR_ENABLE_VPN_GATEWAY=$TF_VAR_ENABLE_VPN_GATEWAY" \
#   -var "TF_VAR_ENABLE_DNS_HOSTNAMES=$TF_VAR_ENABLE_DNS_HOSTNAMES" \
#   -var "TF_VAR_ENABLE_DNS_SUPPORT=$TF_VAR_ENABLE_DNS_SUPPORT" \
#   -var "TF_VAR_TERRAFORM=$TF_VAR_TERRAFORM"

# # Apply Terraform changes
# terraform apply -auto-approve \
#   -var "TF_VAR_NAME=${{ secrets.TF_VAR_NAME }}" \
#   -var "TF_VAR_ENV=${{ secrets.TF_VAR_ENV }}" \
#   -var "TF_VAR_VPC_CIDR=${{ secrets.TF_VAR_VPC_CIDR }}" \
#   -var "TF_VAR_PUBLIC_SUBNETS_CIDR=${{ secrets.TF_VAR_PUBLIC_SUBNETS_CIDR }}" \
#   -var "TF_VAR_PRIVATE_SUBNETS_CIDR=${{ secrets.TF_VAR_PRIVATE_SUBNETS_CIDR }}" \
#   -var "TF_VAR_AVAILABILITY_ZONES=${{ secrets.TF_VAR_AVAILABILITY_ZONES }}" \
#   -var "TF_VAR_EC2_AMI=${{ secrets.TF_VAR_EC2_AMI }}" \
#   -var "TF_VAR_EC2_INSTANCE_TYPE=${{ secrets.TF_VAR_EC2_INSTANCE_TYPE }}" \
#   -var "TF_VAR_ENABLE_VPN_GATEWAY=${{ secrets.TF_VAR_ENABLE_VPN_GATEWAY }}" \
#   -var "TF_VAR_ENABLE_DNS_HOSTNAMES=${{ secrets.TF_VAR_ENABLE_DNS_HOSTNAMES }}" \
#   -var "TF_VAR_ENABLE_DNS_SUPPORT=${{ secrets.TF_VAR_ENABLE_DNS_SUPPORT }}" \
#   -var "TF_VAR_TERRAFORM=${{ secrets.TF_VAR_TERRAFORM }}" \
#   -var "TF_VAR_AWS_ACCOUNT_ID=${{ secrets.TF_VAR_AWS_ACCOUNT_ID }}" \
#   -var "TF_VAR_AWS_REGION=${{ secrets.TF_VAR_AWS_REGION }}" \
#   -var "TF_VAR_AWS_PROFILE=${{ secrets.TF_VAR_AWS_PROFILE }}" \
#   -var "TF_VAR_AWS_ACCESS_KEY_ID=${{ secrets.TF_VAR_AWS_ACCESS_KEY_ID }}" \
#   -var "TF_VAR_AWS_SECRET_ACCESS_KEY=${{ secrets.TF_VAR_AWS_SECRET_ACCESS_KEY }}" \
#   -var "TF_VAR_AWS_SESSION_TOKEN=${{ secrets.TF_VAR_AWS_SESSION_TOKEN }}"

terraform plan \
  -var "TF_VAR_NAME=$TF_VAR_NAME" \
  -var "TF_VAR_ENV=$TF_VAR_ENV" \
  -var "TF_VAR_VPC_CIDR=$TF_VAR_VPC_CIDR" \
  -var "TF_VAR_PUBLIC_SUBNETS_CIDR=$TF_VAR_PUBLIC_SUBNETS_CIDR" \
  -var "TF_VAR_PRIVATE_SUBNETS_CIDR=$TF_VAR_PRIVATE_SUBNETS_CIDR" \
  -var "TF_VAR_AVAILABILITY_ZONES=$TF_VAR_AVAILABILITY_ZONES" \
  -var "TF_VAR_EC2_AMI=$TF_VAR_EC2_AMI" \
  -var "TF_VAR_EC2_INSTANCE_TYPE=$TF_VAR_EC2_INSTANCE_TYPE" \
  -var "TF_VAR_AWS_ACCESS_KEY_ID=$TF_VAR_AWS_ACCESS_KEY_ID" \
  -var "TF_VAR_AWS_SECRET_ACCESS_KEY=$TF_VAR_AWS_SECRET_ACCESS_KEY" \
  -var "TF_VAR_AWS_SESSION_TOKEN=$TF_VAR_AWS_SESSION_TOKEN" \
  -var "TF_VAR_AWS_ACCOUNT_ID=$TF_VAR_AWS_ACCOUNT_ID" \
  -var "TF_VAR_AWS_REGION=$TF_VAR_AWS_REGION" \
  -var "TF_VAR_AWS_PROFILE=$TF_VAR_AWS_PROFILE" \
  -var "TF_VAR_ENABLE_VPN_GATEWAY=$TF_VAR_ENABLE_VPN_GATEWAY" \
  -var "TF_VAR_ENABLE_DNS_HOSTNAMES=$TF_VAR_ENABLE_DNS_HOSTNAMES" \
  -var "TF_VAR_ENABLE_DNS_SUPPORT=$TF_VAR_ENABLE_DNS_SUPPORT" \
  -var "TF_VAR_TERRAFORM=$TF_VAR_TERRAFORM"

#Apply Terraform changes with auto-approval and passing variables
terraform apply \
  -auto-approve \
  -var "TF_VAR_NAME=$TF_VAR_NAME" \
  -var "TF_VAR_ENV=$TF_VAR_ENV" \
  -var "TF_VAR_VPC_CIDR=$TF_VAR_VPC_CIDR" \
  -var "TF_VAR_PUBLIC_SUBNETS_CIDR=$TF_VAR_PUBLIC_SUBNETS_CIDR" \
  -var "TF_VAR_PRIVATE_SUBNETS_CIDR=$TF_VAR_PRIVATE_SUBNETS_CIDR" \
  -var "TF_VAR_AVAILABILITY_ZONES=$TF_VAR_AVAILABILITY_ZONES" \
  -var "TF_VAR_EC2_AMI=$TF_VAR_EC2_AMI" \
  -var "TF_VAR_EC2_INSTANCE_TYPE=$TF_VAR_EC2_INSTANCE_TYPE" \
  -var "TF_VAR_AWS_ACCESS_KEY_ID=$TF_VAR_AWS_ACCESS_KEY_ID" \
  -var "TF_VAR_AWS_SECRET_ACCESS_KEY=$TF_VAR_AWS_SECRET_ACCESS_KEY" \
  -var "TF_VAR_AWS_SESSION_TOKEN=$TF_VAR_AWS_SESSION_TOKEN" \
  -var "TF_VAR_AWS_ACCOUNT_ID=$TF_VAR_AWS_ACCOUNT_ID" \
  -var "TF_VAR_AWS_REGION=$TF_VAR_AWS_REGION" \
  -var "TF_VAR_AWS_PROFILE=$TF_VAR_AWS_PROFILE" \
  -var "TF_VAR_ENABLE_VPN_GATEWAY=$TF_VAR_ENABLE_VPN_GATEWAY" \
  -var "TF_VAR_ENABLE_DNS_HOSTNAMES=$TF_VAR_ENABLE_DNS_HOSTNAMES" \
  -var "TF_VAR_ENABLE_DNS_SUPPORT=$TF_VAR_ENABLE_DNS_SUPPORT" \
  -var "TF_VAR_TERRAFORM=$TF_VAR_TERRAFORM"

#Destroy Terraform changes with auto-approval and passing variables
  terraform destroy \
  -auto-approve \

# set -e

# source_path="$1"
# repository_url="$2"
# tag="${3:-latest}"

# region="$(echo "$repository_url" | cut -d. -f4)"
# image_name="$(echo "$repository_url" | cut -d/ -f2)"

# cd "$source_path"

# # Authenticate with ECR
# aws ecr get-login-password --region "$region" | docker login --username AWS --password-stdin "$repository_url"

# # Build the Docker image
# docker build -t "$image_name" .

# # Tag the Docker image
# docker tag "$image_name" "$repository_url":"$tag"

# # Push the Docker image to ECR
# docker push "$repository_url":"$tag"



# set -e

# source_path="$1"
# repository_url="$2"
# tag="${3:-latest}"

# region="$(echo "$repository_url" | cut -d. -f4)"
# image_name="$(echo "$repository_url" | cut -d/ -f2)"

# (cd "$source_path" && docker build -t "$image_name" .)

# aws ecr get-login-password --region "$region" | docker login --username AWS --password-stdin "$repository_url"
# docker tag "$image_name" "$repository_url":"$tag"
# docker push "$repository_url":"$tag"