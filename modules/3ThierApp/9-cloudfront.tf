# ACM Certificates for CloudFront
# resource "aws_acm_certificate" "cloudfront_certificate" {
#   provider                  = aws.us_east_1
#   domain_name               = var.domain_name
#   validation_method         = "DNS"
#   subject_alternative_names = ["*.${var.domain_name}"]
# }

# resource "aws_acm_certificate_validation" "cloudfront_certificate" {
#   provider                = aws.us_east_1
#   certificate_arn         = aws_acm_certificate.cloudfront_certificate.arn
#   validation_record_fqdns = [aws_route53_record.generic_certificate_validation.fqdn]
# }