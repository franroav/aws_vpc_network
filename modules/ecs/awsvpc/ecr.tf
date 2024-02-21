# # ******************************************************* REPOSITORY ** ECR SETTINGS ***************************************************************


# # CREATE REPOSITORIES

# resource "aws_ecr_repository" "ecr_repos" {

#   for_each = local.ecr_repos

#   name                 = each.value
#   image_tag_mutability = "MUTABLE"

#   # this is very usefull because aws offers the capability of scannig docker images
#   # it will be scanning if there is a hight vulnerability or a critical error, it will look for the operation system and the application 
#   image_scanning_configuration {
#     scan_on_push = true
#   }

#   force_delete = true # Add this line to force delete non-empty repositories

#   tags = {
#     env  = "dev"
#     name = "${each.value}"
#   }
# }