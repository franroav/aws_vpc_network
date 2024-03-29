#!/bin/bash
set -e

# VPC MODULE
export TF_VAR_NAME="terraform-vpc"
export TF_VAR_ENV="production"
export TF_VAR_VPC_CIDR="10.0.0.0/16"
export TF_VAR_PUBLIC_SUBNETS_CIDR="[\"10.0.0.0/20\", \"10.0.16.0/20\"]"
export TF_VAR_PRIVATE_SUBNETS_CIDR="[\"10.0.32.0/24\", \"10.0.33.0/24\"]"
export TF_VAR_AVAILABILITY_ZONES="[\"us-east-1a\", \"us-east-1b\"]"
export TF_VAR_EC2_AMI="ami-011899242bb902164"
export TF_VAR_EC2_INSTANCE_TYPE="t2.nano"
export TF_VAR_AWS_ACCESS_KEY_ID="$TF_VAR_AWS_ACCESS_KEY_ID"
export TF_VAR_AWS_SECRET_ACCESS_KEY="$TF_VAR_AWS_SECRET_ACCESS_KEY"
export TF_VAR_AWS_SESSION_TOKEN="$TF_VAR_AWS_SESSION_TOKEN"
export TF_VAR_AWS_ACCOUNT_ID="$TF_VAR_AWS_ACCOUNT_ID"
export TF_VAR_AWS_REGION="us-east-1"
export TF_VAR_AWS_PROFILE="system-admin"
export TF_VAR_ENABLE_VPN_GATEWAY=true
export TF_VAR_ENABLE_DNS_HOSTNAMES=true
export TF_VAR_ENABLE_DNS_SUPPORT=true
export TF_VAR_TERRAFORM=true

# Install necessary dependencies...
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

# Apply Terraform changes
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