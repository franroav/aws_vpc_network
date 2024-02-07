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


# # Initialize Terraform
# terraform init

# # Validate Terraform configuration
# terraform validate

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
  -var 'TF_VAR_NAME=terraform-vpc' \
  -var 'TF_VAR_ENV=production' \
  -var 'TF_VAR_VPC_CIDR=10.0.0.0/16' \
  -var 'TF_VAR_PUBLIC_SUBNETS_CIDR=["10.0.0.0/20", "10.0.16.0/20"]' \
  -var 'TF_VAR_PRIVATE_SUBNETS_CIDR=["10.0.32.0/24", "10.0.33.0/24"]' \
  -var 'TF_VAR_AVAILABILITY_ZONES=["us-east-1a", "us-east-1b"]' \
  -var 'TF_VAR_EC2_AMI=ami-011899242bb902164' \
  -var 'TF_VAR_EC2_INSTANCE_TYPE=t2.nano' \
  -var 'TF_VAR_AWS_ACCESS_KEY_ID=ASIA5NAGIDAVIFZMZC7N' \
  -var 'TF_VAR_AWS_SECRET_ACCESS_KEY=/j6049XQp3IZ5fg+lueADxzOH7U/DOA+lxDLaer2' \
  -var 'TF_VAR_AWS_SESSION_TOKEN=IQoJb3JpZ2luX2VjEPj//////////wEaCXVzLWVhc3QtMSJHMEUCIAvBuRoKmcuHJRqrCb3lptapXHep6gKXs4BzYoENYj4qAiEA2C53Rsfo398s2uNrquuYxfLbLKvedcnIsmRqJ+OFYT4q9AEIwf//////////ARAAGgw5MjEyODM1OTgzNzgiDLM34cPf81RKYfGj7SrIAfD8YQbVpZFGAtBbzMPKv3BcjyNOuOTmDQKW98P/8H54E+3/BANre65hx5mb98ZDK8mXQterEblb8XqjL9qBmsXLfoJNaGaUJGmTBQY9FYtioEO4llRmecShFnm9tef8LjAq/yXY4CjvC2piS39hMyB9aoL3/VkW/oRbS6rpZ1hcPf4KznYLYZWpCoLkGPyK7zDA3ZC+LVF5E35K3M9Lh5dh1ZBM5agI7KEdQdY1GrOrFSmbVSl+l6tNqO2m+Y2JwS9xTfRMpHCqMMWwia4GOpgBBRsyTFS+vsPInGdV5zrKh/FQa3o2ypeRx2EUrujXXAvR5hKKOVEHF76VktVfX8/J3sq/MKYJandKSH914GjZNFjkRCKKLhhfJhWWnDLUQs5D2yoAOC76g4g17t9SigIbwT8tGS64NikpWIjzMgllRGEByzeiXCMoPi08JZKbSQ8aiPQBjb35rW3X3A9+Vj77zKdkqwODQqA=' \
  -var 'TF_VAR_AWS_ACCOUNT_ID=921283598378' \
  -var 'TF_VAR_AWS_REGION=us-east-1' \
  -var 'TF_VAR_AWS_PROFILE=system-admin' \
  -var 'TF_VAR_ENABLE_VPN_GATEWAY=true' \
  -var 'TF_VAR_ENABLE_DNS_HOSTNAMES=true' \
  -var 'TF_VAR_ENABLE_DNS_SUPPORT=true' \
  -var 'TF_VAR_TERRAFORM=true'

#Apply Terraform changes with auto-approval and passing variables
terraform apply \
  -auto-approve \
  -var 'TF_VAR_NAME=terraform-vpc' \
  -var 'TF_VAR_ENV=production' \
  -var 'TF_VAR_VPC_CIDR=10.0.0.0/16' \
  -var 'TF_VAR_PUBLIC_SUBNETS_CIDR=["10.0.0.0/20", "10.0.16.0/20"]' \
  -var 'TF_VAR_PRIVATE_SUBNETS_CIDR=["10.0.32.0/24", "10.0.33.0/24"]' \
  -var 'TF_VAR_AVAILABILITY_ZONES=["us-east-1a", "us-east-1b"]' \
  -var 'TF_VAR_EC2_AMI=ami-011899242bb902164' \
  -var 'TF_VAR_EC2_INSTANCE_TYPE=t2.nano' \
  -var 'TF_VAR_AWS_ACCESS_KEY_ID=ASIA5NAGIDAVIFZMZC7N' \
  -var 'TF_VAR_AWS_SECRET_ACCESS_KEY=/j6049XQp3IZ5fg+lueADxzOH7U/DOA+lxDLaer2' \
  -var 'TF_VAR_AWS_SESSION_TOKEN=IQoJb3JpZ2luX2VjEPj//////////wEaCXVzLWVhc3QtMSJHMEUCIAvBuRoKmcuHJRqrCb3lptapXHep6gKXs4BzYoENYj4qAiEA2C53Rsfo398s2uNrquuYxfLbLKvedcnIsmRqJ+OFYT4q9AEIwf//////////ARAAGgw5MjEyODM1OTgzNzgiDLM34cPf81RKYfGj7SrIAfD8YQbVpZFGAtBbzMPKv3BcjyNOuOTmDQKW98P/8H54E+3/BANre65hx5mb98ZDK8mXQterEblb8XqjL9qBmsXLfoJNaGaUJGmTBQY9FYtioEO4llRmecShFnm9tef8LjAq/yXY4CjvC2piS39hMyB9aoL3/VkW/oRbS6rpZ1hcPf4KznYLYZWpCoLkGPyK7zDA3ZC+LVF5E35K3M9Lh5dh1ZBM5agI7KEdQdY1GrOrFSmbVSl+l6tNqO2m+Y2JwS9xTfRMpHCqMMWwia4GOpgBBRsyTFS+vsPInGdV5zrKh/FQa3o2ypeRx2EUrujXXAvR5hKKOVEHF76VktVfX8/J3sq/MKYJandKSH914GjZNFjkRCKKLhhfJhWWnDLUQs5D2yoAOC76g4g17t9SigIbwT8tGS64NikpWIjzMgllRGEByzeiXCMoPi08JZKbSQ8aiPQBjb35rW3X3A9+Vj77zKdkqwODQqA=' \
  -var 'TF_VAR_AWS_ACCOUNT_ID=921283598378' \
  -var 'TF_VAR_AWS_REGION=us-east-1' \
  -var 'TF_VAR_AWS_PROFILE=system-admin' \
  -var 'TF_VAR_ENABLE_VPN_GATEWAY=true' \
  -var 'TF_VAR_ENABLE_DNS_HOSTNAMES=true' \
  -var 'TF_VAR_ENABLE_DNS_SUPPORT=true' \
  -var 'TF_VAR_TERRAFORM=true'

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