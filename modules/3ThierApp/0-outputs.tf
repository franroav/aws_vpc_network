# output "web_lb_id" {
#   value = aws_lb.web.id
# }


output "vpc_id" {
  value = aws_vpc.vpc_prod.id
}

output "app_subnet_ids" {
  value = [aws_subnet.app_a.id, aws_subnet.app_b.id]
}

output "web_subnet_ids" {
  value = [aws_subnet.web_a.id, aws_subnet.web_b.id]
}

output "db_subnet_ids" {
  value = [aws_subnet.db_a.id, aws_subnet.db_b.id]
}

output "certificate_arn" {
  value = aws_acm_certificate.certificate.arn
}

# output "certificate_validation_records" {
#   value = aws_acm_certificate_validation.certificate.validation_record_fqdns
# }


# output "app_security_group_id" {
#   value = aws_security_group.app.id
# }

# output "db_security_group_id" {
#   value = aws_security_group.db_sg.id
# }

output "load_balancer_dns_name" {
  value = aws_lb.web.dns_name
}

output "web_target_group_arn" {
  value = aws_lb_target_group.web_target_group.arn
}

output "app_target_group_arn" {
  value = aws_lb_target_group.app_target_group.arn
}

output "rds_cluster_primary_endpoint" {
  value = aws_rds_cluster.aws_rds_cluster_prod_primary.endpoint
}

output "rds_cluster_standby_endpoint" {
  value = aws_rds_cluster.aws_rds_cluster_prod_standby.endpoint
}