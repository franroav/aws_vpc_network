

/* -------------------------------------------------------------------------- */
/*                                   NETWORK                                   */
/* -------------------------------------------------------------------------- */


/*==== The VPC ======*/
resource "aws_vpc" "vpc" {
  cidr_block           = var.TF_VAR_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name        = "${var.TF_VAR_env}-vpc"
    Environment = "${var.TF_VAR_env}"
  }
}

/*==== Subnets ======*/
/* Internet gateway for the public subnet */
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id #|| "${module.networking.vpc.vpc_id}" 
  tags = {
    Name        = "${var.TF_VAR_env}-igw"
    Environment = "${var.TF_VAR_env}"
  }
}
/* Elastic IP for NAT */
resource "aws_eip" "nat_eip" {
  # vpc        = true
  domain     = "vpc"
  depends_on = [aws_internet_gateway.ig]
}
/* NAT */
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.public_subnet.*.id, 0)
  depends_on    = [aws_internet_gateway.ig]
  tags = {
    Name        = "nat"
    Environment = "${var.TF_VAR_env}"
  }
}
/* Public subnet */
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.TF_VAR_public_subnets_cidr)
  cidr_block              = element(var.TF_VAR_public_subnets_cidr, count.index)
  availability_zone       = element(var.TF_VAR_availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name        = "${var.TF_VAR_env}-${element(var.TF_VAR_availability_zones, count.index)}-public-subnet"
    Environment = "${var.TF_VAR_env}"
  }
}
/* Private subnet */
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.TF_VAR_private_subnets_cidr)
  cidr_block              = element(var.TF_VAR_private_subnets_cidr, count.index)
  availability_zone       = element(var.TF_VAR_availability_zones, count.index)
  map_public_ip_on_launch = false
  tags = {
    Name        = "${var.TF_VAR_env}-${element(var.TF_VAR_availability_zones, count.index)}-private-subnet"
    Environment = "${var.TF_VAR_env}"
  }
}
/* Routing table for private subnet */
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "${var.TF_VAR_env}-private-route-table"
    Environment = "${var.TF_VAR_env}"
  }
}
/* Routing table for public subnet */
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "${var.TF_VAR_env}-public-route-table"
    Environment = "${var.TF_VAR_env}"
  }
}
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id
}
resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}
/* Route table associations */
resource "aws_route_table_association" "public" {
  count          = length(var.TF_VAR_public_subnets_cidr)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "private" {
  count          = length(var.TF_VAR_private_subnets_cidr)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private.id
}
/*==== VPC's Default Security Group ======*/
resource "aws_security_group" "default" {
  name        = "${var.TF_VAR_env}-default-sg"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = aws_vpc.vpc.id
  depends_on  = [aws_vpc.vpc]
  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = "true"
  }
  tags = {
    Environment = "${var.TF_VAR_env}"
  }
}


/* -------------------------------------------------------------------------- */
/*                               EC2 SSH KEY RESOURCES                              */
/* -------------------------------------------------------------------------- */

/*==== KEY PAIR ======*/
resource "aws_key_pair" "TF_key" {
  key_name   = "TF_key"
  public_key = tls_private_key.rsa.public_key_openssh
}

# RSA key of size 4096 bits
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

/*==== LOCAL FILE ======*/
resource "local_file" "TF-key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "tfkey"
}

/* -------------------------------------------------------------------------- */
/*                                   COMPUTE RESOURCES                        */
/* -------------------------------------------------------------------------- */

/*==== EC2 Instances in Public Subnet ======*/
resource "aws_instance" "public_instances" {
  count         = length(var.TF_VAR_public_subnets_cidr)
  ami           = var.TF_VAR_ec2_ami # Ubuntu 20.04 LTS // us-east-1
  instance_type = var.TF_VAR_ec2_instance_type
  subnet_id     = element(aws_subnet.public_subnet.*.id, count.index)
  #   key_name      = var.TF_VAR_key_pair_names["Public-Instance-${count.index}"]   # Use the dynamic key pair
  key_name = "TF_key"
  tags = {
    Name = "Public-Instance-${count.index}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

/*==== EC2 Instances in Private Subnet ======*/
resource "aws_instance" "private_instances" {
  count         = length(var.TF_VAR_private_subnets_cidr)
  ami           = var.TF_VAR_ec2_ami # Ubuntu 20.04 LTS // us-east-1
  instance_type = var.TF_VAR_ec2_instance_type
  subnet_id     = element(aws_subnet.private_subnet.*.id, count.index)
  #   key_name      = var.TF_VAR_key_pair_names["Private-Instance-${count.index}"]   # Use the dynamic key pair
  key_name = "TF_key"
  tags = {
    Name = "Private-Instance-${count.index}"
  }

  lifecycle {
    create_before_destroy = true
  }
}


/* -------------------------------------------------------------------------- */
/*                                  MONITORING RESOURCES                      */
/* -------------------------------------------------------------------------- */

/*==== CloudWatch Logs ======*/
resource "aws_cloudwatch_log_group" "ec2_log_group" {
  count = length(concat(aws_instance.public_instances, aws_instance.private_instances))
  name  = "EC2-Log-Group-${count.index}"

  tags = {
    Service     = "EC2"
    Environment = "${var.TF_VAR_env}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# resource "aws_key_pair" "key_pairs" {
# #   for_each = toset(var.TF_VAR_key_pair_names)
#     key_name = "my_ssh_keys"
#     public_key = file("~/.aws/my_ssh_keys.pem")
# #   key_name   = each.value
# #   public_key = file("~/.aws/${each.value}.pub")  # Replace with the path to your public key file
# }

# # ECDSA key with P384 elliptic curve
# resource "tls_private_key" "ecdsa-p384-example" {
#   algorithm   = "ECDSA"
#   ecdsa_curve = "P384"
# }



# # ED25519 key
# resource "tls_private_key" "ed25519-example" {
#   algorithm = "ED25519"
# }




