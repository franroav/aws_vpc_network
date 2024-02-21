resource "aws_eks_cluster" "eks" {
  name     = "pc-eks"
  role_arn = aws_iam_role.master.arn


  vpc_config {
    subnet_ids = [
      module.vpc.public_subnets[0],
      module.vpc.public_subnets[1],
      module.vpc.private_subnets[0],
      module.vpc.private_subnets[1],
      module.vpc.intra_subnets[0],
      module.vpc.intra_subnets[1],
    ]

    # Other VPC configurations...
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
    #aws_subnet.pub_sub1,
    #aws_subnet.pub_sub2,
  ]
  
}


# # module "vpc" {
# #   source = "./network.tf"  // Update the path to your VPC module
# #   // Pass any necessary variables to the VPC module
# # }

# module "eks" {
#   source  = "terraform-aws-modules/eks/aws"
#   version = "19.15.1"

#   cluster_name                   = local.name
#   cluster_endpoint_public_access = true

#   cluster_addons = {
#     coredns = {
#       most_recent = true
#     }
#     kube-proxy = {
#       most_recent = true
#     }
#     vpc-cni = {
#       most_recent = true
#     }
#   }

#   vpc_id                   = module.vpc.vpc_id
#   subnet_ids               = module.vpc.private_subnets
#   control_plane_subnet_ids = module.vpc.intra_subnets

#   # EKS Managed Node Group(s)
#   eks_managed_node_group_defaults = {
#     ami_type       = "AL2_x86_64"
#     instance_types = ["m5.large"]

#     attach_cluster_primary_security_group = true
#   }

#   eks_managed_node_groups = {
#     ascode-cluster-wg = {
#       min_size     = 1
#       max_size     = 2
#       desired_size = 1

#       instance_types = ["t3.large"]
#       capacity_type  = "SPOT"

#       tags = {
#         ExtraTag = "helloworld"
#       }
#     }
#   }

#   tags = local.tags

#     depends_on = [
#     module.managed_node_group_role,
#   ]
# }