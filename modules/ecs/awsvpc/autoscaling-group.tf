##############################################################################
# AUTO SCALING GROUPS
##############################################################################
resource "aws_autoscaling_group" "public-autoscaling-group" {
name                 = "public-autoscaling-group"
  max_size             = 2
  min_size             = 1
  desired_capacity     = 2
  vpc_zone_identifier  = ["${aws_subnet.public-subnet.0.id}", "${aws_subnet.public-subnet.1.id}"]
  launch_configuration = aws_launch_configuration.webserver-ecs-launch-configuration.name
  target_group_arns    = [aws_alb_target_group.public-ecs-target-group.arn]
  # lifecycle {
  #   prevent_destroy = true
  # }
}

# Create a new ALB Target Group attachment
resource "aws_autoscaling_attachment" "public" {
  autoscaling_group_name = aws_autoscaling_group.public-autoscaling-group.id
  lb_target_group_arn    = aws_alb_target_group.public-ecs-target-group.arn
  # target_group_arn = aws_alb_target_group.public-ecs-target-group.arn
}
