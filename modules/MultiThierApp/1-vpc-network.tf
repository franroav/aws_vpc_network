/* -------------------------------------------------------------------------- */
/*                               NETWORKING                                   */
/* -------------------------------------------------------------------------- */

resource "aws_vpc" "vpc_prod" {
  tags       = merge(var.tags, {})
  cidr_block = var.cidr_block
}

resource "aws_subnet" "app_b" {
  vpc_id            = aws_vpc.vpc_prod.id
  tags              = merge(var.tags, { Name = var.web_subnets.b.name })
  cidr_block        = var.app_subnets.b.cidr
  availability_zone = "us-east-1b"
}

resource "aws_subnet" "web_b" {
  vpc_id            = aws_vpc.vpc_prod.id
  tags              = merge(var.tags, { Name = var.web_subnets.b.name })
  cidr_block        = var.web_subnets.b.cidr
  availability_zone = "us-east-1b"
}

resource "aws_subnet" "web_a" {
  vpc_id            = aws_vpc.vpc_prod.id
  tags              = merge(var.tags, { Name = var.web_subnets.a.name })
  cidr_block        = var.web_subnets.a.cidr
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "app_a" {
  vpc_id            = aws_vpc.vpc_prod.id
  tags              = merge(var.tags, { Name = var.app_subnets.a.name })
  cidr_block        = var.app_subnets.a.cidr
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "db_a" {
  vpc_id            = aws_vpc.vpc_prod.id
  tags              = merge(var.tags, {})
  cidr_block        = var.db_subnets.a.cidr
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "db_b" {
  vpc_id            = aws_vpc.vpc_prod.id
  tags              = merge(var.tags, {})
  cidr_block        = var.db_subnets.b.cidr
  availability_zone = "us-east-1b"
}

resource "aws_db_subnet_group" "aws_db_private_subnet_group" {
  tags = merge(var.tags, {})

  subnet_ids = [
    aws_subnet.db_a.id,
    aws_subnet.db_b.id,
  ]
}


# data "aws_route53_zone" "certificate_route53_zone" {
#   name         = var.root_domain_name #"awsfranroavdeveloper.click"
#   private_zone = false
#   vpc_id       = "vpc-07c8cf108237c3587"  # Replace with the correct VPC ID
# }

# data "aws_vpcs" "current" {}

# locals {
#   matching_vpc_id = try(
#     [for vpc in data.aws_vpcs.current.ids : vpc.id if contains(vpc.vpc_id, data.aws_route53_zone.certificate_route53_zone.vpc_id)],
#     []
#   )
# }

# data "aws_acm_certificate" "imported_certificate" {
#   domain   = "awsfranroavdeveloper.click"
#   statuses = ["ISSUED"]
# }



# resource "aws_route53_zone" "certificate_route53_zone" {
#   count = length(aws_subnet.app_a)

#   name          = "${element(aws_subnet.app_a[count.index].tags.Name, 0)}."
#   # private_zone  = false
#   # vpc_id        = aws_subnet.app_a[count.index].vpc_id
#   force_destroy = true
# }


# data "aws_route53_zone" "certificate_route53_zone" {
#   name         = var.root_domain_name
#   private_zone = false
# }
# data "aws_route53_zone" "certificate_route53_zone" {
#   name         = "awsfranroavdeveloper.click"
#   private_zone = false
#   vpc_id       = aws_vpc.vpc_prod.id
# }

# resource "aws_route53_record" "cert_dns" {
#   for_each = {
#     for robo in aws_acm_certificate.certificate.domain_validation_options : robo.domain_name => {
#       name   = robo.resource_record_name
#       record = robo.resource_record_value
#       type   = robo.resource_record_type
#     }
#   }

#   allow_overwrite = true
#   name            = each.value.name
#   records         = [each.value.record]
#   ttl             = 60
#   type            = each.value.type
#   zone_id         = data.aws_route53_zone.certificate_route53_zone.zone_id
# }

# resource "aws_acm_certificate_validation" "certificate" {
#   certificate_arn         = aws_acm_certificate.certificate.arn
#   validation_record_fqdns = [for record in aws_route53_record.cert_dns : record.fqdn]
# }


# data "aws_route53_zone" "certificate_route53_zone" {
#   name         = var.root_domain_name
#   private_zone = false
#   # zone_id      = "/hostedzone/Z09435041HFQPEAGYWNHL" # Use the correct hosted zone ID
# }





# ACM Certificate Data Source
# data "aws_acm_certificate" "certificate" {
#   domain      = "www.awsfranroavdeveloper.click"
#   statuses    = ["ISSUED"]
#   most_recent = true
# }

# module "vpc" {
#   source = "./"  // Update the path to your VPC module

#   // Pass any necessary variables to the VPC module
# }


# resource "aws_acm_certificate" "certificate" {
#   domain_name               = aws_route53_zone.domain.name
#   validation_method         = "DNS"
#   subject_alternative_names = ["*.${aws_route53_zone.domain.name}"]

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# # ALB Listener
# resource "aws_lb_listener" "alb_front_https" {
#   load_balancer_arn = aws_lb.web.arn
#   port              = 443
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = "arn:aws:acm:us-east-1:921283598378:certificate/616dffb7-b4ad-4dca-94b9-4a649ea9638a"

#   default_action {
#     target_group_arn = aws_lb_target_group.web_target_group.arn
#     type             = "forward"
#   }
# }

# resource "aws_lb_listener_certificate" "ssl_certificate" {
#   listener_arn    = aws_lb_listener.alb_front_https.arn
#   certificate_arn = aws_acm_certificate.certificate.arn  # Correct reference
# }








# resource "aws_lb_listener" "alb_front_https" {
#   load_balancer_arn = aws_lb.web.arn
#   port              = 443
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
#   certificate_arn   = aws_acm_certificate.certificate.arn  # Correct reference
#   default_action {
#     target_group_arn = aws_lb_target_group.web_target_group.arn
#     type             = "forward"
#   }
# }


# # IAM Server Certificate for ALB
# resource "aws_iam_server_certificate" "lb_certificate" {
#   name              = "lb_certificate"
#   certificate_body  = data.aws_acm_certificate.certificate.certificate_body
#   private_key       = data.aws_acm_certificate.certificate.private_key
#   certificate_chain = data.aws_acm_certificate.certificate.certificate_chain
# }

# resource "aws_acm_certificate" "alb_certificate" {
#   domain_name               = aws_route53_zone.domain.name
#   validation_method         = "DNS"
#   subject_alternative_names = ["*.${aws_route53_zone.domain.name}"]

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_route53_record" "validation_route53_record" {
#   for_each = {
#     for idx, val in aws_acm_certificate.alb_certificate.domain_validation_options : idx => val.resource_record_name
#   }

#   name    = each.value
#   type    = aws_acm_certificate.alb_certificate.domain_validation_options[each.key].resource_record_type
#   records = [aws_acm_certificate.alb_certificate.domain_validation_options[each.key].resource_record_value]
#   ttl     = 60
#   zone_id = aws_route53_zone.domain.id
# }

# resource "aws_acm_certificate_validation" "alb_certificate" {
#   certificate_arn         = aws_acm_certificate.alb_certificate.arn
#   validation_record_fqdns = [for record in aws_route53_record.validation_route53_record : record.fqdn]

#   depends_on = [aws_route53_record.validation_route53_record]

#   timeouts {
#     create = "5m" # Adjust the timeout as needed, e.g., 5 minutes
#   }
# }






