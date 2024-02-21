# --- ECS Task Role ---

data "aws_iam_policy_document" "ecs_task_doc" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_role" {
  name_prefix        = "demo-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_doc.json
}

resource "aws_iam_role" "ecs_exec_role" {
  name_prefix        = "demo-ecs-exec-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_doc.json
}

resource "aws_iam_role_policy_attachment" "ecs_exec_role_policy" {
  role       = aws_iam_role.ecs_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}





resource "aws_iam_role" "ecs-instance-role" {
  name               = "ecs-instance-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ecs-instance-policy.json
}

data "aws_iam_policy_document" "ecs-instance-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs-instance-role-attachment" {
  role       = aws_iam_role.ecs-instance-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}


resource "aws_iam_instance_profile" "ecs-instance-profile" {
  name = "ecs-instance-profile"
  path = "/"

  //  roles = ["${aws_iam_role.ecs-instance-role.id}"]
  role = aws_iam_role.ecs-instance-role.id

  provisioner "local-exec" {
    command = "sleep 10"
  }
}

data "aws_iam_policy_document" "ecs_service_policy" {
  statement {
    actions   = [
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:RegisterTargets", 
      "elasticloadbalancing:DeregisterTargets"
    ]
    resources = ["*"]
    effect    = "Allow"
  }
}

resource "aws_iam_role_policy" "ecs_service_policy" {
  name   = "ecs_service_policy"
  role   = aws_iam_role.ecs_task_role.id
  policy = data.aws_iam_policy_document.ecs_service_policy.json
}