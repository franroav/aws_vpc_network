# IAM Role for EC2 Instances
resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

# IAM Policy for Route 53 Updates
resource "aws_iam_policy" "route53_policy" {
  name        = "route53_policy"
  description = "IAM policy for Route 53 updates"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action   = "route53:ChangeResourceRecordSets",
      Effect   = "Allow",
      Resource = "*"
    }]
  })
}

# Attach the Route 53 policy to the IAM role
resource "aws_iam_role_policy_attachment" "route53_attachment" {
  policy_arn = aws_iam_policy.route53_policy.arn
  role       = aws_iam_role.ec2_role.name
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "app" {
  name  = "app_instance_profile"
  role = aws_iam_role.ec2_role.name
}