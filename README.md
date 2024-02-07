# AWS VPC NETWORK 🌟

## Multi-tier Architecture Overview

The network layout described in the resources.tf file represents a typical multi-tier architecture for cloud-based applications. This architecture segregates components into different layers based on their functions and security requirements. 
Divides resources into multiple layers based on functionality and security requirements. Typically includes public, private, and database subnets. Provides enhanced security by isolating sensitive components

Here's the type of network layout it involves:


The network layout includes the following components:

1. **VPC**: The main networking construct that isolates resources in the cloud.
2. **Public Subnets**: Subnets where public-facing resources, such as web servers, reside. These subnets have routes to the internet gateway.
3. **Private Subnets**: Subnets where internal resources, such as databases or application servers, reside. These subnets do not have direct routes to the internet; instead, they route traffic through NAT gateways.
4. **Internet Gateway**: Provides access to the internet for resources in the public subnets.
5. **NAT Gateway**: Allows resources in private subnets to access the internet while remaining private.
6. **Route Tables**: Define routes for traffic within the VPC, ensuring proper routing between subnets and gateways.
7. **EC2 Instances**: Both public and private EC2 instances for various application deployments.
8. **Key Pair**: Used for SSH access to EC2 instances for administration purposes.
9. **CloudWatch Log Groups**: Monitor logs and events from EC2 instances for troubleshooting and auditing purposes.

## Getting Started

Follow these steps to initialize and deploy the infrastructure:

### Prerequisites

1. Install [Terraform](https://www.terraform.io/downloads.html).
2. Configure AWS credentials using AWS CLI (`aws configure sso`) or environment variables.
3. Set up settings using AWS CLI with region (`default`), format (`json`), profile (`system-admin`)
3. Get AWS Credentials using AWS CLI (`aws sts get-session-token`) and set up on terraform.tfvars && github actions secrets 

### Directory Structure

- .
- ├── main.tf
- ├── modules
- │   └── [Your Modules]
- ├── production.tf
- ├── README.md
- ├── terraform.tfstate
- ├── terraform.tfstate.backup
- ├── terraform.tfvars
- └── variables.tf

### Terraform Commands
- **terraform init**: Initialization resources.
- **terraform plan**: Preview changes before applying.
- **terraform apply**: Deploy the infrastructure.
- **terraform destroy**: Destroy the deployed infrastructure.

## Variables 🔢

- Update `terraform.tfvars` with your specific values.

## Variables AWS Configure SSO terraform.tfvars

- **TF_VAR_AWS_ACCESS_KEY_ID=**"xxxxxxxxxxxxxxxxxxx"
- **TF_VAR_AWS_SECRET_ACCESS_KEY=**"xxxxxxxxxxxxxxxxxxxxx"
- **TF_VAR_AWS_SESSION_TOKEN=**"xxxxxxxxxxxxxxxxxxxxxxxxx="
- **TF_VAR_AWS_ACCOUNT_ID**=0000000000000
- **TF_VAR_AWS_REGION=**"xxxxxxxxxx"
- **TF_VAR_AWS_PROFILE=**"xxxxxxxxxxxxxxxx"
- **TF_VAR_env**                  = "xxxxxxxxxxx"
- **TF_VAR_vpc_cidr**             = "xx.x.x.x/xx"
- **TF_VAR_public_subnets_cidr**  = ["xx.x.x.x/xx", "xx.x.x.x/xx"]
- **TF_VAR_private_subnets_cidr** = ["xx.x.x.x/xx", "xx.x.x.x/xx"]
- **TF_VAR_availability_zones**   = ["xx-xxxx-xx", "xx-xxxx-xx"]
- **TF_VAR_name** = "terraform-vpc"
- **TF_VAR_enable_vpn_gateway**   = true
- **TF_VAR_enable_dns_hostnames** = true
- **TF_VAR_enable_dns_support**   = true
- **TF_VAR_terraform = true**


## Resources

### 1. AWS CloudWatch Log Groups (EC2) 📊

- **Name**: "EC2-Log-Group-[0-3]"
- **Retention**: 0 days
- **Tags**: Environment (sensitive), Service: EC2
- **Description**: CloudWatch Log Groups for EC2 instances to monitor logs and events.

### 2. AWS Elastic IP (EIP) for NAT 🌐

- **Allocation ID**: (known after apply)
- **Tags**: VPC: true
- **Description**: Elastic IP for NAT gateway to provide a static public IP for outbound internet traffic.

### 3. Private EC2 Instances 💻

- **Type**: t2.nano
- **Key**: TF_key
- **Tags**: Name: "Private-Instance-[0-1]"
- **Description**: Private EC2 instances for internal services, not directly accessible from the internet.

### 4. Public EC2 Instances 💻

- **Type**: t2.nano
- **Key**: TF_key
- **Tags**: Name: "Public-Instance-[0-1]"
- **Description**: Public-facing EC2 instances for hosting applications accessible from the internet.

### 5. AWS Internet Gateway 🌐

- **Tags**: Environment (sensitive), Name (sensitive)
- **Description**: Internet Gateway for connecting the VPC to the internet.

### 6. AWS Key Pair (TF_key) 🔐🔑

- **Key Name**: TF_key
- **Description**: Key pair for secure SSH access to EC2 instances.

### 7. AWS NAT Gateway 🌐

- **Tags**: Environment (sensitive), Name: "nat"
- **Description**: NAT Gateway for private instances to access the internet while remaining private.

### 8. Private NAT Gateway Route 🌐

- **Destination**: 0.0.0.0/0
- **Description**: Route for private subnet instances to route traffic through the NAT Gateway.

### 9. Public Internet Gateway Route 🌐

- **Destination**: 0.0.0.0/0
- **Description**: Route for public subnet instances to route traffic directly to the internet.

### 10. Private Route Table 🗺️

- **Tags**: Environment (sensitive), Name (sensitive)
- **Description**: Route table for private subnets, defining routes and associating with private subnets.

### 11. Public Route Table 🗺️

- **Tags**: Environment (sensitive), Name (sensitive)
- **Description**: Route table for public subnets, defining routes and associating with public subnets.

### 12. Private Subnets 🌐

- **Availability Zones**: "us-east-1a", "us-east-1b"
- **Tags**: Environment (sensitive), Name (sensitive)
- **Description**: Subnets for private instances, not directly accessible from the internet.

### 13. Public Subnets 🌐

- **Availability Zones**: "us-east-1a", "us-east-1b"
- **Tags**: Environment (sensitive), Name (sensitive)
- **Description**: Subnets for public instances, accessible from the internet.

### 14. AWS VPC 🌐

- **Tags**: Environment (sensitive), Name (sensitive)
- **Description**: Virtual Private Cloud (VPC) for organizing and isolating resources.

### 15. Local File (TF-key) 📁📄

- **Filename**: "tfkey"
- **Directory Permission**: 0777
- **File Permission**: 0777
- **Description**: Local file containing the Terraform key pair for EC2 instances.

### 16. TLS Private Key (RSA) 🔐🔑

- **Algorithm**: RSA
- **RSA Bits**: 4096
- **Description**: RSA private key for securing communication within the infrastructure.

### 17. Terraform Provider "aws" ⚙️

- **Version**: 3.0
- **Description**: Terraform AWS provider for managing AWS resources.

### 18. Terraform Local File "TF-key" 📁📄

- **Content**: (sensitive value)
- **Description**: Local file containing the Terraform key pair for EC2 instances.

### 19. Terraform TLS Private Key "RSA" 🔐🔑

- **Algorithm**: RSA
- **RSA Bits**: 4096
- **Description**: Terraform TLS provider for generating RSA private key.

### 20. Terraform AWS VPC 🌐

- **CIDR Block**: (sensitive value)
- **Description**: Terraform module for creating AWS VPC.

### 21. Terraform AWS Subnet (Private) 🌐

- **Availability Zone**: "us-east-1b"
- **CIDR Block**: (sensitive value)
- **Description**: Terraform module for creating private subnets within the VPC.

### 22. Terraform AWS Subnet (Public) 🌐

- **Availability Zone**: "us-east-1a", "us-east-1b"
- **CIDR Block**: (sensitive value)
- **Description**: Terraform module for creating public subnets within the VPC.