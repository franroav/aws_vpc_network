##############################################################################
# PUBLIC Zone Load Balancing
##############################################################################
resource "aws_alb" "public-load-balancer" {
  name            = "public-load-balancer"
  security_groups = ["${aws_security_group.ecs_sg.id}"]

  subnets = [
    "${aws_subnet.public-subnet.0.id}",
    "${aws_subnet.public-subnet.1.id}",
  ]
}

resource "aws_alb_target_group" "public-ecs-target-group" {
  name     = "public-ecs-target-group"
  port     = 8081
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  # health_check {
  #   healthy_threshold   = 5
  #   unhealthy_threshold = 2
  #   interval            = 30
  #   matcher             = "200"
  #   path                = "/"
  #   port                = "traffic-port"
  #   protocol            = "HTTP"
  #   timeout             = 5
  # }

  # depends_on = [
  #   aws_alb.public-load-balancer,
  # ]
  # target_type = "instance"
  # target_type = "ip"
  #   tags {
  #     Name = "public-ecs-target-group"
  #   }
}

resource "aws_alb_listener" "public-alb-listener" {
  load_balancer_arn = aws_alb.public-load-balancer.arn
  port              = 8081
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.public-ecs-target-group.arn
    type             = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
      message_body = "OK"
    }
  }

  # depends_on = [
  #   aws_alb_target_group.public-ecs-target-group,
  # ]
}

