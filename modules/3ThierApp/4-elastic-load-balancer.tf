/* -------------------------------------------------------------------------- */
/*                               SECURITY GROUPS                              */
/* -------------------------------------------------------------------------- */

# Creating Security Group for ELB
resource "aws_security_group" "app" {
  name        = "Demo Security Group"
  description = "Demo Module"
  vpc_id      = aws_vpc.vpc_prod.id
  # Inbound Rules
  # HTTP access 
  ingress {
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = [var.web_subnets.a.cidr, var.web_subnets.b.cidr, var.app_subnets.a.cidr, var.app_subnets.b.cidr]
  }
  # HTTPS access from anywhere
  ingress {
    from_port   = var.https_port
    to_port     = var.https_port
    protocol    = "tcp"
    cidr_blocks = [var.web_subnets.a.cidr, var.web_subnets.b.cidr, var.app_subnets.a.cidr, var.app_subnets.b.cidr]
  }
  # SSH access from vpc ID's or / anywhere #["0.0.0.0/0"]
  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = [var.web_subnets.a.cidr, var.web_subnets.b.cidr, var.app_subnets.a.cidr, var.app_subnets.b.cidr] #["0.0.0.0/0"]
  }
  # Outbound Rules
  # Traffic to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Creating Security Group for the Database Tier
resource "aws_security_group" "db_sg" {
  name        = "db-security-group"
  description = "Security group for the database tier"
  vpc_id      = aws_vpc.vpc_prod.id # Replace with your VPC ID

  # Inbound Rules
  ingress {
    from_port   = var.db_port # Assuming MySQL database
    to_port     = var.db_port
    protocol    = "tcp"
    cidr_blocks = [var.db_subnets.a.cidr, var.db_subnets.b.cidr]
  }

  # Add more inbound rules as needed

  # Outbound Rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

/* -------------------------------------------------------------------------- */
/*                               LOAD BALANCER                                */
/* -------------------------------------------------------------------------- */
# In AWS, a load balancer can't be attached to multiple subnets in the same Availability Zone.
resource "aws_lb" "web" {
  name            = "web-elb"
  tags            = merge(var.tags, {})
  security_groups = [aws_security_group.app.id]
  # cross_zone_load_balancing = true

  # availability_zones = ["us-east-1a", "us-east-1b"]

  subnets = [
    aws_subnet.web_a.id,
    aws_subnet.web_b.id,
    # Use subnets from different Availability Zones for app
    # aws_subnet.app_a.id,
    # aws_subnet.app_b.id,
  ]
}

resource "aws_lb_target_group" "web_target_group" {
  name     = "web-target-group"
  port     = var.app_port
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc_prod.id

  # depends_on = ["aws_lb.web"]
}

resource "aws_lb_target_group" "app_target_group" {
  name     = "app-target-group"
  port     = var.app_port
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc_prod.id

  # depends_on = ["aws_lb.web"]
}

resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web.id
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.certificate.arn
  default_action {
    target_group_arn = aws_lb_target_group.web_target_group.arn

    type = "forward"
  }
}

# resource "aws_lb_listener" "web_listener" {
#   load_balancer_arn = aws_lb.web.id
#   port              = "443"
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = aws_acm_certificate.certificate.arn
#   default_action {
#     target_group_arn = [
#       aws_lb_target_group.web_target_group.arn,
#       aws_lb_target_group.app_target_group.arn,
#     ]
#     type = "forward"
#   }
# }



# resource "aws_elb" "web" {
#   # name               = "${var.app_name}-${var.environment}" # Naming our load balancer
#   # # Referencing the security group
#   # security_groups = [aws_security_group.load_balancer_security_group.id]
#   name                      = "web-elb"
#   tags                      = merge(var.tags, {})
#   security_groups           = [aws_security_group.app.id]
#   cross_zone_load_balancing = true
#   # security_groups = [
#   #   "${aws_security_group.app.id}"
#   # ]
#   # availability_zones = [
#   #   "us-east-1a",
#   #   "us-east-1b",
#   # ]

#   # instances = aws_autoscaling_group.web.launch_configuration.id  # Use the launch configuration ID

#   # instances = [aws_autoscaling_group.web.id]
#   # instances = aws_autoscaling_group.web.id


#   # instances = [
#   #   for instance in aws_autoscaling_group.web.instances : instance.id
#   # ]
#   # instances = [
#   #   aws_autoscaling_group.web.*.id,  # Update this line to reference your EC2 instances
#   # ]

#   subnets = [
#     aws_subnet.web_a.id,
#     aws_subnet.web_b.id,
#     aws_subnet.app_a.id,
#     aws_subnet.app_b.id,
#   ]

#   # health_check {
#   #   healthy_threshold   = 2
#   #   unhealthy_threshold = 2
#   #   timeout             = 3
#   #   interval            = 30
#   #   target              = "HTTP:80/"
#   # }

#   listener {
#     lb_protocol        = "HTTPS"
#     lb_port            = var.https_port # Update this to your HTTPS port
#     instance_protocol  = "HTTP"
#     instance_port      = var.app_port
#     ssl_certificate_id = aws_acm_certificate.alb_certificate.arn
#   }
# }


# resource "aws_elb" "aws_elb_14_c" {
#   name                      = "aws_elb_14_c"
#   cross_zone_load_balancing = true
#   tags = merge(var.tags, {})

#   instances = [
#     aws_autoscaling_group.web.id,
#   ]

#   subnets = [
#     aws_subnet.web_a.id,
#     aws_subnet.web_b.id,
#   ]

#   listener {
#     lb_protocol       = "http"
#     lb_port           = var.app_port
#     instance_protocol = "http"
#     instance_port     = var.app_port
#   }
# }


