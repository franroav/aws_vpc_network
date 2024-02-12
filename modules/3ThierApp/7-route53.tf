/* -------------------------------------------------------------------------- */
/*                               ROUTE 53                                   */
/* -------------------------------------------------------------------------- */
# Define the Route 53 zone for the domain
resource "aws_route53_zone" "domain" {
  name = "awsfranroavdeveloper.click"
}

/* -------------------------------------------------------------------------- */
/*                               ACM - SSL CERTIFICATE                        */
/* -------------------------------------------------------------------------- */

resource "aws_route53_zone" "certificate_route53_zone" {
  name         = var.root_domain_name
}

resource "aws_acm_certificate" "certificate" {
  domain_name               = var.root_domain_name
  subject_alternative_names = ["*.${var.root_domain_name}"]
  validation_method         = "DNS"
  # domain_name               = "awsfranroavdeveloper.click"
  # validation_method         = "DNS"
  # subject_alternative_names = ["*.awsfranroavdeveloper.click"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_dns" {
  for_each = {
    for robo in aws_acm_certificate.certificate.domain_validation_options : robo.domain_name => {
      name   = robo.resource_record_name
      record = robo.resource_record_value
      type   = robo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.certificate_route53_zone.zone_id
}

resource "aws_acm_certificate_validation" "certificate" {
  certificate_arn         = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_dns : record.fqdn]
}


# resource "aws_route53_record" "domain" {
#   count = length(aws_autoscaling_group.web.instances)

#   zone_id = aws_route53_zone.domain.zone_id
#   name    = "awsfranroavdeveloper.click"
#   type    = "A"
#   ttl     = "300"

#   records = [aws_autoscaling_group.web.instances[count.index].private_ip]
# }