
# # module "ecs" {
# #   source                  = "./ECS"
# #   vpc_id                  = data.aws_vpc.existing.id
# #   cluster_name            = "demo-api-cluster"
# #   cluster_service_name    = "cloudquicklabs-api-service"
# #   cluster_service_task_name = "cloudquicklabs-api-task"
# #   vpc_id_subnet_list      = [var.vpc_id_subnet_list[0], var.vpc_id_subnet_list[1], var.vpc_id_subnet_list[2], var.vpc_id_subnet_list[3]]
# # #   task_role_arn      = aws_iam_role.ecs_task_role.arn
# #   execution_role_arn = aws_iam_role.ecs_exec_role.arn
# #   image_id                = ""#"${aws_ecr_repository.ecr_repos["api"].repository_url}:latest"#"357171621133.dkr.ecr.us-west-2.amazonaws.com/ecsdemo:latest"
# # }

# # data "aws_vpc" "existing" {
# # #   cidr_block = var.vpc_cidr
# #   id = var.vpc_id  
# #   tags = {
# #     Name        = "${var.TF_VAR_env}-vpc"s
# #     Environment = "${var.TF_VAR_env}"
# #   }
# # }

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name        = "${var.TF_VAR_env}-vpc"
    Environment = "${var.TF_VAR_env}"
  }
}

# --- subnets ---

resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.vpc_id_subnet_list)               # "${length(var.availability_zones)}"
  cidr_block              = element(var.vpc_id_subnet_list, count.index) # "${var.public_subnets[count.index]}"
  map_public_ip_on_launch = true
  availability_zone       = element(var.availability_zones, count.index) #"${var.availability_zones[count.index]}"


  tags = {
    Name = "public-subnet-${count.index}"
  }
}


/* Internet gateway for the public subnet */
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id #|| "${module.networking.vpc.vpc_id}" 
  tags = {
    Name        = "${var.TF_VAR_env}-igw"
    Environment = "${var.TF_VAR_env}"
  }
}
/* Elastic IP for NAT */
resource "aws_eip" "nat_eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.igw]
}
/* NAT */
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.public-subnet.*.id, 0) #element(aws_subnet.public_subnet.*.id, 0)
  depends_on    = [aws_internet_gateway.igw]
  tags = {
    Name        = "nat"
    Environment = "${var.TF_VAR_env}"
  }
}

# --- routing tables ---
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "public-route-table-assoc" {
  count          = length(var.availability_zones)
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = element(aws_subnet.public-subnet.*.id, count.index)
}

# resource "aws_route_table" "private-route-table" {
#   vpc_id = aws_vpc.vpc.id

#   tags = {
#     Name = "private-route-table"
#   }
# }

# resource "aws_route" "private-route" {
#   route_table_id         = aws_route_table.private-route-table.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = aws_nat_gateway.nat.id
# }

# resource "aws_route_table_association" "private-route-table-assoc" {
#   count          = length(var.availability_zones)
#   route_table_id = aws_route_table.private-route-table.id
#   subnet_id      = element(aws_subnet.private-subnet.*.id, count.index)
# }

# resource "aws_route_table_association" "database-route-table-assoc" {
#   count          = length(var.availability_zones)
#   route_table_id = aws_route_table.private-route-table.id
#   subnet_id      = element(aws_subnet.database-subnet.*.id, count.index)
# }

##########################################################################
# CLUSTER
##########################################################################

resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name
}

# ******************************************************* AWS ECS API TASK ** ECS SETTINGS ***************************************************************

resource "aws_ecs_task_definition" "api_task_definition" {
  family                   = var.cluster_service_task_name
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  requires_compatibilities = ["FARGATE"]

  task_role_arn      = aws_iam_role.ecs_task_role.arn
  execution_role_arn = aws_iam_role.ecs_exec_role.arn
  #   execution_role_arn    = var.execution_role_arn 


  container_definitions = jsonencode([
    {
      name   = "api"
      image  = "${var.TF_VAR_AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/api-repo:latest" #"var.image_id
      cpu    = 256
      memory = 512
      port_mappings = [
        {
          container_port = 8081
          host_port      = 8081
          protocol       = "tcp"
        }
      ]
    }
  ])
}


# ******************************************************* AWS ECS API SERVICE ** ECS SETTINGS ***************************************************************
resource "aws_ecs_service" "api_service" {
  name            = var.cluster_service_name
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.api_task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

 load_balancer {
    target_group_arn = aws_alb_target_group.public-ecs-target-group.arn
    container_port   = 8081
    container_name   = "api" #"${var.TF_VAR_app_name}-${var.TF_VAR_env}-api"
  }

  network_configuration {
    subnets = [
      "${aws_subnet.public-subnet.0.id}",
      "${aws_subnet.public-subnet.1.id}",
    ]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
}


# # ******************************************************* AWS ECS FRONTEND TASK ** ECS SETTINGS ***************************************************************

# resource "aws_ecs_task_definition" "frontend_task_definition" {
#   family                   = var.cluster_service_task_name
#   network_mode             = "awsvpc"
#   cpu                      = 256
#   memory                   = 256
#   requires_compatibilities = ["FARGATE"]

#   task_role_arn      = aws_iam_role.ecs_task_role.arn
#   execution_role_arn = aws_iam_role.ecs_exec_role.arn
#   #   execution_role_arn    = var.execution_role_arn 


#   container_definitions = jsonencode([
#     {
#       name   = "frontend"
#       image  = "${var.TF_VAR_AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/frontend-repo:latest" #"var.image_id
#       cpu    = 256
#       memory = 512
#       port_mappings = [
#         {
#           container_port = 80
#           host_port      = 80
#           protocol       = "tcp"
#         }
#       ]
#     }
#   ])
# }


# # ******************************************************* AWS ECS FRONTEND SERVICE ** ECS SETTINGS ***************************************************************
# resource "aws_ecs_service" "frontend_service" {
#   name            = var.cluster_service_name
#   cluster         = aws_ecs_cluster.ecs_cluster.id
#   task_definition = aws_ecs_task_definition.task_definition.arn
#   desired_count   = 1
#   launch_type     = "FARGATE"

#  load_balancer {
#     target_group_arn = aws_alb_target_group.public-ecs-target-group.arn
#     container_port   = 80
#     container_name   = "frontend" #"${var.TF_VAR_app_name}-${var.TF_VAR_env}-api"
#   }

#   network_configuration {
#     subnets = [
#       "${aws_subnet.public-subnet.0.id}",
#       "${aws_subnet.public-subnet.1.id}",
#     ]
#     security_groups  = [aws_security_group.ecs_sg.id]
#     assign_public_ip = true
#   }
# }

# ##############################################################################
# # NETWORK
# ##############################################################################

# resource "aws_vpc" "vpc" {
#   cidr_block = var.vpc_cidr

#   tags = {
#     Name        = "${var.TF_VAR_env}-vpc"
#     Environment = "${var.TF_VAR_env}"
#   }
# }

# # --- subnets ---

# resource "aws_subnet" "public-subnet" {
#   vpc_id                  = aws_vpc.vpc.id
#   count                   = length(var.vpc_id_subnet_list)               # "${length(var.availability_zones)}"
#   cidr_block              = element(var.vpc_id_subnet_list, count.index) # "${var.public_subnets[count.index]}"
#   map_public_ip_on_launch = true
#   availability_zone       = element(var.availability_zones, count.index) #"${var.availability_zones[count.index]}"


#   tags = {
#     Name = "public-subnet-${count.index}"
#   }
# }


# /* Internet gateway for the public subnet */
# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.vpc.id #|| "${module.networking.vpc.vpc_id}" 
#   tags = {
#     Name        = "${var.TF_VAR_env}-igw"
#     Environment = "${var.TF_VAR_env}"
#   }
# }
# /* Elastic IP for NAT */
# resource "aws_eip" "nat_eip" {
#   domain     = "vpc"
#   depends_on = [aws_internet_gateway.igw]
# }
# /* NAT */
# resource "aws_nat_gateway" "nat" {
#   allocation_id = aws_eip.nat_eip.id
#   subnet_id     = element(aws_subnet.public-subnet.*.id, 0) #element(aws_subnet.public_subnet.*.id, 0)
#   depends_on    = [aws_internet_gateway.igw]
#   tags = {
#     Name        = "nat"
#     Environment = "${var.TF_VAR_env}"
#   }
# }

# # --- routing tables ---
# resource "aws_route_table" "public-route-table" {
#   vpc_id = aws_vpc.vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }

#   tags = {
#     Name = "public-route-table"
#   }
# }

# resource "aws_route_table_association" "public-route-table-assoc" {
#   count          = length(var.availability_zones)
#   route_table_id = aws_route_table.public-route-table.id
#   subnet_id      = element(aws_subnet.public-subnet.*.id, count.index)
# }



# ##############################################################################
# # PUBLIC Zone Load Balancing
# ##############################################################################
# resource "aws_alb" "public-load-balancer" {
#   name            = "public-load-balancer"
#   security_groups = ["${aws_security_group.ecs_sg.id}"]

#   subnets = [
#     "${aws_subnet.public-subnet.0.id}",
#     "${aws_subnet.public-subnet.1.id}",
#   ]
# }

# resource "aws_alb_target_group" "public-ecs-target-group" {
#   name     = "public-ecs-target-group"
#   port     = 8081
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.vpc.id
#   target_type = "ip"

#   health_check {
#     healthy_threshold   = 5
#     unhealthy_threshold = 2
#     interval            = 30
#     matcher             = "200"
#     path                = "/"
#     port                = "traffic-port"
#     protocol            = "HTTP"
#     timeout             = 5
#   }

#   # depends_on = [
#   #   aws_alb.public-load-balancer,
#   # ]
#   # target_type = "instance"

#   #   tags {
#   #     Name = "public-ecs-target-group"
#   #   }
# }

# resource "aws_alb_listener" "public-alb-listener" {
#   load_balancer_arn = aws_alb.public-load-balancer.arn
#   port              = 8081
#   protocol          = "HTTP"

#   default_action {
#     target_group_arn = aws_alb_target_group.public-ecs-target-group.arn
#     type             = "fixed-response"
#     fixed_response {
#       content_type = "text/plain"
#       status_code  = "200"
#       message_body = "OK"
#     }
#   }

#   depends_on = [
#     aws_alb.public-load-balancer,
#   ]
# }


# # resource "aws_route_table" "private-route-table" {
# #   vpc_id = aws_vpc.vpc.id

# #   tags = {
# #     Name = "private-route-table"
# #   }
# # }

# # resource "aws_route" "private-route" {
# #   route_table_id         = aws_route_table.private-route-table.id
# #   destination_cidr_block = "0.0.0.0/0"
# #   nat_gateway_id         = aws_nat_gateway.nat.id
# # }

# # resource "aws_route_table_association" "private-route-table-assoc" {
# #   count          = length(var.availability_zones)
# #   route_table_id = aws_route_table.private-route-table.id
# #   subnet_id      = element(aws_subnet.private-subnet.*.id, count.index)
# # }

# # resource "aws_route_table_association" "database-route-table-assoc" {
# #   count          = length(var.availability_zones)
# #   route_table_id = aws_route_table.private-route-table.id
# #   subnet_id      = element(aws_subnet.database-subnet.*.id, count.index)
# # }


# ##########################################################################
# # ECR
# ##########################################################################


# # Create the frontend-repo repository
# # resource "aws_ecr_repository" "frontend_repo" {
# #   name = "frontend-repo"  # Specify the name of the repository
# # }

# # # Create the api-repo repository
# # resource "aws_ecr_repository" "api_repo" {
# #   name = "api-repo"  # Specify the name of the repository
# # }

# # # frontend repository
# data "aws_ecr_repository" "frontend_repo" {
#   name = "frontend-repo"
# }

# # api repository
# data "aws_ecr_repository" "api_repo" {
#   name = "api-repo"
# }

# ##########################################################################
# # CLUSTER
# ##########################################################################

# resource "aws_ecs_cluster" "ecs_cluster" {
#   name = var.cluster_name
# }

# # ******************************************************* AWS ECS API TASK ** ECS SETTINGS ***************************************************************

# resource "aws_ecs_task_definition" "api_task_definition" {
#   family                   = var.cluster_service_task_name
#   network_mode             = "awsvpc"
#   cpu                      = 256
#   memory                   = 512
#   requires_compatibilities = ["FARGATE"]

#   task_role_arn      = aws_iam_role.ecs_task_role.arn
#   execution_role_arn = aws_iam_role.ecs_exec_role.arn
#   #   execution_role_arn    = var.execution_role_arn 


#   container_definitions = jsonencode([
#     {
#       name   = "api"
#       image  = "${data.aws_ecr_repository.api_repo.repository_url}:latest"
#       cpu    = 256
#       memory = 512
#       portMappings = [
#           {
#               "containerPort": 8081,
#               "hostPort": 8081,
#               "protocol": "tcp"
#           }
#       ],
#       # port_mappings = [
#       #   {
#       #     container_port = 8081
#       #     host_port      = 8081
#       #     protocol       = "tcp"
#       #   }
#       # ]
#     }
#   ])
# }


# # ******************************************************* AWS ECS API SERVICE ** ECS SETTINGS ***************************************************************
# resource "aws_ecs_service" "api_service" {
#   name            = var.cluster_service_name
#   cluster         = aws_ecs_cluster.ecs_cluster.id
#   task_definition = aws_ecs_task_definition.api_task_definition.arn
#   desired_count   = 1
#   launch_type     = "FARGATE"

#   load_balancer {
#     target_group_arn = aws_alb.public-load-balancer.arn
#     container_port   = 8081
#     container_name   = "api"
#   }

# #  load_balancer {
# #     target_group_arn = aws_alb_target_group.public-ecs-target-group.arn
# #     container_port   = 8081
# #     container_name   = "api" #"${var.TF_VAR_app_name}-${var.TF_VAR_env}-api"
# #   }

#   network_configuration {
#     subnets = [
#       "${aws_subnet.public-subnet.0.id}",
#       "${aws_subnet.public-subnet.1.id}",
#     ]
#     security_groups  = [aws_security_group.ecs_sg.id]
#     assign_public_ip = true
#   }
# }


# # # ******************************************************* AWS ECS FRONTEND TASK ** ECS SETTINGS ***************************************************************

# resource "aws_ecs_task_definition" "frontend_task_definition" {
#   family                   = var.cluster_service_task_name
#   network_mode             = "awsvpc"
#   cpu                      = 256
#   memory                   = 512
#   requires_compatibilities = ["FARGATE"]

#   task_role_arn      = aws_iam_role.ecs_task_role.arn
#   execution_role_arn = aws_iam_role.ecs_exec_role.arn
#   #   execution_role_arn    = var.execution_role_arn 


#   container_definitions = jsonencode([
#     {
#       name   = "frontend"
#       image  = "${data.aws_ecr_repository.frontend_repo.repository_url}:latest"
#       cpu    = 256
#       memory = 512
#       portMappings = [
#           {
#               "containerPort": 80,
#               "hostPort": 80,
#               "protocol": "tcp"
#           }
#       ],
#       # port_mappings = [
#       #   {
#       #     container_port = 80
#       #     host_port      = 80
#       #     protocol       = "tcp"
#       #   }
#       # ]
#     }
#   ])
# }


# # # ******************************************************* AWS ECS FRONTEND SERVICE ** ECS SETTINGS ***************************************************************
# resource "aws_ecs_service" "frontend_service" {
#   name            = var.cluster_service_name
#   cluster         = aws_ecs_cluster.ecs_cluster.id
#   task_definition = aws_ecs_task_definition.frontend_task_definition.arn
#   desired_count   = 1
#   launch_type     = "FARGATE"

#   load_balancer {
#     target_group_arn = aws_alb.public-load-balancer.arn
#     container_port   = 80
#     container_name   = "frontend"
#   }

# #  load_balancer {
# #     target_group_arn = aws_alb_target_group.public-ecs-target-group.arn
# #     container_port   = 80
# #     container_name   = "frontend" #"${var.TF_VAR_app_name}-${var.TF_VAR_env}-api"
# #   }

#   network_configuration {
#     subnets = [
#       "${aws_subnet.public-subnet.0.id}",
#       "${aws_subnet.public-subnet.1.id}",
#     ]
#     security_groups  = [aws_security_group.ecs_sg.id]
#     assign_public_ip = true
#   }
# }