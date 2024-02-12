

/* -------------------------------------------------------------------------- */
/*                               EC2 AMAZON MACHINE IMAGE                     */
/* -------------------------------------------------------------------------- */

data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "architecture"
    values = ["arm64"]
  }
  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
}

/* -------------------------------------------------------------------------- */
/*                               EC2 LAUNCH CONFIGURATION                     */
/* -------------------------------------------------------------------------- */

resource "aws_launch_configuration" "app" {
  name_prefix   = "asg-launch-config"
  instance_type = "t4g.nano"
  image_id      = data.aws_ami.this.id

  user_data = <<-EOF
              #!/bin/bash
              PRIVATE_IP=\$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
              
              # Check if AWS CLI is installed
              if command -v aws >/dev/null 2>&1; then
                # Update Route 53 record
                aws route53 change-resource-record-sets \
                  --hosted-zone-id ${aws_route53_zone.domain.zone_id} \
                  --change-batch '{
                    "Changes": [
                      {
                        "Action": "UPSERT",
                        "ResourceRecordSet": {
                          "Name": "awsfranroavdeveloper.click",
                          "Type": "A",
                          "TTL": 300,
                          "ResourceRecords": [
                            {
                              "Value": "\$PRIVATE_IP"
                            }
                          ]
                        }
                      }
                    ]
                  }'
              else
                echo "AWS CLI not found. Please install it for Route 53 updates."
                exit 1
              fi
              EOF

  # Additional security settings
  iam_instance_profile = aws_iam_instance_profile.app.name

  # Ensure instances are replaced when the launch configuration changes
  lifecycle {
    create_before_destroy = true
  }
}

/* -------------------------------------------------------------------------- */
/*                               APP AUTO SCALING GROUP                       */
/* -------------------------------------------------------------------------- */

resource "aws_autoscaling_group" "app" {
  name                 = "asg-app"
  min_size             = var.app_asg_min
  max_size             = var.app_asg_max
  # desired_capacity     = var.app_asg_max  # Increase the desired capacity
  launch_configuration = aws_launch_configuration.app.name
  vpc_zone_identifier  = [aws_subnet.app_a.id, aws_subnet.app_b.id]


# Additional settings for high availability
  health_check_type    = "ELB"
  force_delete         = true
  # availability_zones    = ["us-east-1a", "us-east-1b", "us-east-1c"]  # Add more AZs as needed

  # metrics_granularity = "1Minute"

  # launch_template {
  #   id      = aws_launch_configuration.app.id
  #   version = "$Latest"
  # }

  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }
}

# Create a new ALB Target Group attachment
resource "aws_autoscaling_attachment" "app" {
  autoscaling_group_name = aws_autoscaling_group.app.id
  lb_target_group_arn    = aws_lb_target_group.app_target_group.arn
}

/* -------------------------------------------------------------------------- */
/*                               WEB AUTO SCALING GROUP                       */
/* -------------------------------------------------------------------------- */

resource "aws_autoscaling_group" "web" {
  name                 = "asg-web"
  min_size             = var.web_asg_min
  max_size             = var.web_asg_max
  desired_capacity     = var.web_asg_max
  launch_configuration = aws_launch_configuration.app.name
  vpc_zone_identifier  = [aws_subnet.web_a.id, aws_subnet.web_b.id]
  # health_check_type    = "ELB"
  # load_balancers       = ["${aws_lb.web.id}"]
  # force_delete         = true


  lifecycle {
    create_before_destroy = true
  }
}

# Create a new ALB Target Group attachment
resource "aws_autoscaling_attachment" "web" {
  autoscaling_group_name = aws_autoscaling_group.web.id
  lb_target_group_arn    = aws_lb_target_group.web_target_group.arn
}


# data "aws_ami" "ubuntu" {
#   most_recent = true

#   owners      = ["099720109477"] # Canonical
#   # name        = "ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"
#   # virtualization_type = "hvm"
# }

# resource "aws_launch_configuration" "app" {
#   name_prefix   = "asg-launch-config"
#   instance_type = "t4g.nano"
#   image_id      = data.aws_ami.this.id

#   # security_groups = [ "${aws_security_group.demosg.id}" ]
#   # associate_public_ip_address = true
#   # user_data = "${file("data.sh")}"

#   lifecycle {
#     create_before_destroy = true
#   }
# }