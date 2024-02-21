
resource "aws_iam_role" "instance_profile_role" {
  name = "instance-profile-role"
  
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Effect" : "Allow",
      "Principal" : {
        "Service" : "ec2.amazonaws.com"
      },
      "Action" : "sts:AssumeRole"
    }]
  })
} 

resource "aws_iam_role_policy" "instance_profile_policy" {
  name   = "instance-profile-policy"
  role   = aws_iam_role.instance_profile_role.name

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowPullMainImages",
        "Effect" : "Allow",
        "Action" : [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ],
        "Resource" : [
          "arn:aws:ecr:*:*:repository/filebeat",
          "arn:aws:ecr:*:*:repository/base"
        ]
      },
      {
        "Sid" : "AllowCreateRespositry",
        "Effect" : "Allow",
        "Action" : "ecr:CreateRepository",
        "Resource" : "*"
      },
      {
        "Sid" : "AllowPushandPullImages",
        "Effect" : "Allow",
        "Action" : [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:InitiateLayerUpload",
          "ecr:DeleteRepository",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:ListImages",
          "ecr:BatchDeleteImage",
          "ecr:GetLifecyclePolicy",
          "ecr:PutLifecyclePolicy"
        ],
        "Resource" : [
          "arn:aws:ecr:*:*:repository/*/filebeat",
          "arn:aws:ecr:*:*:repository/*/base"
        ]
      },
      {
        "Sid" : "AllowGetAuthToken",
        "Effect" : "Allow",
        "Action" : "ecr:GetAuthorizationToken",
        "Resource" : "*"
      },
      {
        "Sid" : "AllowDescirbeEKS",
        "Effect" : "Allow",
        "Action" : "eks:DescribeCluster",
        "Resource" : "arn:aws:eks:*:*:cluster/*"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "instance-profile-name"
  role = aws_iam_role.instance_profile_role.name
}

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




resource "aws_instance" "kubectl-server" {
  ami                         = var.TF_VAR_EC2_AMI
  key_name                    = "TF_key"
  instance_type               = var.TF_VAR_EC2_INSTANCE_TYPE
  associate_public_ip_address = true
  subnet_id                   = module.vpc.public_subnets[0] // Assuming you want to use the first public subnet
  vpc_security_group_ids      = [aws_security_group.allow_tls.id]
  iam_instance_profile        =  aws_iam_instance_profile.instance_profile.name

  tags = {
    Name = "kubectl"
  }

  user_data = "${file("scripts/ec2/init.sh")}"


}


resource "aws_eks_node_group" "node-grp" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "pc-node-group"
  node_role_arn   = aws_iam_role.worker.arn

  subnet_ids = [
      module.vpc.public_subnets[0],
      module.vpc.public_subnets[1],
      module.vpc.private_subnets[0],
      module.vpc.private_subnets[1],
      module.vpc.intra_subnets[0],
      module.vpc.intra_subnets[1],
    ]

  capacity_type  = "ON_DEMAND"
  disk_size      = "20"
  instance_types = [var.TF_VAR_EC2_INSTANCE_TYPE]

  remote_access {
    ec2_ssh_key               = "TF_key"
    source_security_group_ids = [aws_security_group.allow_tls.id]
  }

  labels = tomap({ env = "dev" })

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    #aws_subnet.pub_sub1,
    #aws_subnet.pub_sub2,
  ]
}


# provider "kubernetes" {
#   config_path = "~/.kube/config" // Path to your Kubernetes config file
# }

# resource "kubernetes_deployment" "app1_deployment" {
#   metadata {
#     name = "app1-deployment"
#   }

#   spec {
#     replicas = 3 // Number of replicas for the application
#     selector {
#       match_labels = {
#         app = "app1"
#       }
#     }

#     template {
#       metadata {
#         labels = {
#           app = "app1"
#         }
#       }

#       spec {
#         container {
#           image = "your-ecr-repo-url/app1-image:latest" // Replace with your ECR repository URL and image name
#           name  = "app1-container"
#           // Add other container configurations as needed
#         }
#       }
#     }
#   }
# }

# resource "kubernetes_deployment" "app2_deployment" {
#   metadata {
#     name = "app2-deployment"
#   }

#   spec {
#     replicas = 2 // Number of replicas for the application
#     selector {
#       match_labels = {
#         app = "app2"
#       }
#     }

#     template {
#       metadata {
#         labels = {
#           app = "app2"
#         }
#       }

#       spec {
#         container {
#           image = "your-ecr-repo-url/app2-image:latest" // Replace with your ECR repository URL and image name
#           name  = "app2-container"
#           // Add other container configurations as needed
#         }
#       }
#     }
#   }
# }


# resource "aws_instance" "kubectl-server" {
#   ami                         = "ami-063e1495af50e6fd5"
#   key_name                    = "ubuntusingapore"
#   instance_type               = "t2.micro"
#   associate_public_ip_address = true

#   count = length(module.vpc.public_subnets) + length(module.vpc.private_subnets) + length(module.vpc.intra_subnets)

#   subnet_id = element(
#     concat(concat(module.vpc.public_subnets[*].id, module.vpc.private_subnets[*].id), module.vpc.intra_subnets[*].id),
#     count.index
#   )

#   vpc_security_group_ids = [aws_security_group.allow_tls.id]

#   tags = {
#     Name = "kubectl-${count.index}"
#   }
# }