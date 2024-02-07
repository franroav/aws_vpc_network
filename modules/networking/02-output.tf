# output "vpc_id" {
#  value = "${aws_vpc.vpc.id}"
# #   value = "${module.networking.vpc.vpc_id}"
# }

/*==== Outputs ======*/
output "ec2_private_ips" {
  value = { for instance in aws_instance.private_instances : instance.tags.Name => instance.private_ip }
}



output "vpc_id" {
  description = "The ID of the VPC"
  value       = "${aws_vpc.vpc.id}" 
}

output "public_subnet_ids" {
  description = "List of IDs of the public subnets"
  value       = "${aws_subnet.public_subnet[*].id}"  
}

output "private_subnet_ids" {
  description = "List of IDs of the private subnets"
  value       = "${aws_subnet.private_subnet[*].id}"   
}

output "nat_gateway_id" {
  description = "The ID of the NAT gateway"
  value       = "${aws_nat_gateway.nat.id}"  
}

output "public_instance_ids" {
  description = "List of IDs of the public EC2 instances"
  value       = "${aws_instance.public_instances[*].id}" 
}

output "private_instance_ids" {
  description = "List of IDs of the private EC2 instances"
  value       = "${aws_instance.private_instances[*].id}" 
}

output "cloudwatch_log_group_names" {
  description = "List of names of CloudWatch log groups"
  value       = "${aws_cloudwatch_log_group.ec2_log_group[*].name}"  
}
