resource "aws_key_pair" "TF_key" {
  key_name   = "TF_key"
  public_key = tls_private_key.rsa.public_key_openssh
}

# # ECDSA key with P384 elliptic curve
# resource "tls_private_key" "ecdsa-p384-example" {
#   algorithm   = "ECDSA"
#   ecdsa_curve = "P384"
# }

# RSA key of size 4096 bits
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "TF-key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "tfkey"
}


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


resource "aws_launch_configuration" "app" {
  name_prefix   = "asg-launch-config"
  instance_type = "t4g.nano"
  image_id      = data.aws_ami.this.id

  # security_groups = [ "${aws_security_group.demosg.id}" ]
  # associate_public_ip_address = true
  # user_data = "${file("data.sh")}"

  root_block_device {
    volume_type           = "standard"
    volume_size           = 100
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "webserver-ecs-launch-configuration" {
  name                 = "webserver-ecs-launch-configuration"
  image_id             = data.aws_ami.this.id
  instance_type        = "t4g.nano"
  iam_instance_profile = aws_iam_instance_profile.ecs-instance-profile.id

  root_block_device {
    volume_type           = "standard"
    volume_size           = 100
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }

  security_groups             = ["${aws_security_group.ecs_sg.id}"]
  associate_public_ip_address = "true"
  key_name                    = "TF_key" #"${var.ecs_key_pair_name}"

  user_data = <<EOF
#!/bin/bash
echo ECS_CLUSTER=${lookup(var.ecs_cluster_names, "public")} >> /etc/ecs/ecs.config
EOF
}
