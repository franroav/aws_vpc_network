#!/bin/bash

set -e

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
terraform plan

# Apply Terraform changes with auto-approval
terraform apply -auto-approve
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