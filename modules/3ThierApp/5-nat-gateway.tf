# SUBNET WEB B

/* Elastic IP for NAT */
resource "aws_eip" "nat_eip_natgw_c" {
  domain = "vpc"
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "natgw_c" {
  tags          = merge(var.tags, {})
  subnet_id     = aws_subnet.web_b.id
  allocation_id = aws_eip.nat_eip_natgw_c.id
}


# SUBNET WEB A

/* Elastic IP for NAT */
resource "aws_eip" "nat_eip_natgw" {
  domain = "vpc"
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "natgw" {
  tags          = merge(var.tags, {})
  subnet_id     = aws_subnet.web_a.id
  allocation_id = aws_eip.nat_eip_natgw.id
}

# SUBNET APP A

/* Elastic IP for NAT */
resource "aws_eip" "nat_eip_natgw_c_1_c" {
  domain = "vpc"
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "natgw_c_1_c" {
  tags          = merge(var.tags, {})
  subnet_id     = aws_subnet.app_a.id
  allocation_id = aws_eip.nat_eip_natgw_c_1_c.id
}


# SUBNET APP B

/* Elastic IP for NAT */
resource "aws_eip" "nat_eip_natgw_c_c" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "natgw_c_c" {
  tags          = merge(var.tags, {})
  subnet_id     = aws_subnet.app_b.id
  allocation_id = aws_eip.nat_eip_natgw_c_c.id # aws_instance.example1.id  // Replace with your Elastic IP allocation ID
}







# NAT Gateway Redundancy:
#-----------------------------------------------------#
# Add more NAT gateways across different subnets for redundancy.

# These modifications provide better reliability and scalability for your infrastructure. 
# Adjust the values based on your specific requirements and consider implementing additional best practices based on your application's characteristics and usage patterns.

# resource "aws_nat_gateway" "natgw_c_2_c" {
#   tags      = merge(var.tags, {})
#   subnet_id = aws_subnet.app_b.id
#   allocation_id = "${aws_eip.nat_eip_natgw_c_2_c.id}"
# }

# resource "aws_eip" "nat_eip_natgw_c_2_c" {
#   vpc        = true
#   depends_on = [aws_internet_gateway.igw]
# }

# resource "aws_nat_gateway" "natgw_c_3_c" {
#   tags      = merge(var.tags, {})
#   subnet_id = aws_subnet.web_a.id
#   allocation_id = "${aws_eip.nat_eip_natgw_c_3_c.id}"
# }

# resource "aws_eip" "nat_eip_natgw_c_3_c" {
#   vpc        = true
#   depends_on = [aws_internet_gateway.igw]
# }
