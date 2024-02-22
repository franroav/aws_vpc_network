# Role that pods can assume for access to elasticsearch and kibana

resource "aws_iam_role" "elasticsearch_user" {
  name               = "module.user_label.id"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  description = "IAM Role to assume to access the Elasticsearch module.label.id cluster"

  tags = {
    tag-key = "tag-value"
  }
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    effect = "Allow"
  }
}


# Step 1: Define the AWS IAM Policy Document
data "aws_iam_policy_document" "default" {
  statement {
    actions = [
      "es:ESHttp*",
    ]

    resources = [
      aws_elasticsearch_domain.default.arn,
      "${aws_elasticsearch_domain.default.arn}/*"
    ]
    
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"]
    }
  }
}

# Step 2: Define the Data Source to Fetch Public IP Address
# Define the data source to fetch the public IP addresses
data "http" "public_ip_http" {
  url = "http://api64.ipify.org?format=json"
}

data "http" "public_ip_https" {
  url = "https://api64.ipify.org?format=json"
}
# Step 3: Create Elasticsearch Domain Policy with Dynamic IP Address
# Create the Elasticsearch domain policy with dynamic IP addresses
resource "aws_elasticsearch_domain_policy" "default" {
  domain_name = "easyaws"

  access_policies = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "es:ESHttp*",
        Resource  = "${aws_elasticsearch_domain.default.arn}/*",
        Condition = {
          IpAddress = {
            "aws:SourceIp" = [
              // add an ip source to give access to elasticsearch endpoint
              jsondecode(data.http.public_ip_http.body)["ip"],
              jsondecode(data.http.public_ip_https.body)["ip"]

            ]
          }
        }
      }
    ]
  })
}


# resource "aws_iam_role" "elasticsearch_user" {
#   name               = "module.user_label.id"
#   assume_role_policy = join("", data.aws_iam_policy_document.assume_role.*.json)
#   description        = "IAM Role to assume to access the Elasticsearch module.label.id cluster"

#   tags = {
#     tag-key = "tag-value"
#   }
# }

# data "aws_iam_policy_document" "assume_role" {

#   statement {
#     actions = [
#       "sts:AssumeRole"
#     ]

#     principals {
#       type        = "Service"
#       identifiers = ["ec2.amazonaws.com"]
#     }

#     principals {
#       type        = "AWS"
#       identifiers = ["*"]
#     }

#     effect = "Allow"
#   }
# }


# data "aws_iam_policy_document" "default" {
#   statement {
#     actions = [
#       "es:ESHttpDelete",
#       "es:ESHttpGet",
#       "es:ESHttpHead",
#       "es:ESHttpPost",
#       "es:ESHttpPut"
#     ]

#     resources = [
#       aws_elasticsearch_domain.default.arn,
#       "${aws_elasticsearch_domain.default.arn}/*"
#     ]

#     principals {
#       type        = "AWS"
#       identifiers = ["arn:aws:iam::921283598378:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_SystemAdministrator_2327177ae2444e70"]
#     }
#   }
# }

# data "aws_iam_policy_document" "default" {
#   statement {
#     actions = [
#       "es:*",
#     #   "es:ESHttpDelete",
#     #   "es:ESHttpGet",
#     #   "es:ESHttpHead",
#     #   "es:ESHttpPost",
#     #   "es:ESHttpPut"
#     ]

#     resources = [
#       aws_elasticsearch_domain.default.arn,
#       "${aws_elasticsearch_domain.default.arn}/*"
#     ]

#     effect = "Allow"

#     principals {
#       type        = "AWS"
#       identifiers = ["arn:aws:iam::921283598378:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_SystemAdministrator_2327177ae2444e70"]  # Specify the ARN of the IAM role allowed to access
#     }
#   }
# }

# resource "aws_elasticsearch_domain_policy" "default" {
#   domain_name     = "easyaws"
#   access_policies = join("", data.aws_iam_policy_document.default.*.json)
# }

#"easyaws"
# resource "aws_elasticsearch_domain_policy" "default" {
#   domain_name = aws_elasticsearch_domain.default.domain_name 
#   access_policies = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect    = "Allow",
#         Principal = "*",
#         Action    = ["es:ESHttpGet", "es:ESHttpHead"],
#         Resource  = "${aws_elasticsearch_domain.default.arn}/*",
#       },
#       {
#         Effect    = "Deny",
#         Principal = "*",
#         Action    = "es:*",
#         Resource  = "${aws_elasticsearch_domain.default.arn}/*",
#         Condition = {
#           Bool = {
#             "aws:SecureTransport" = "false"
#           }
#         }
#       },
#       {
#         Effect    = "Deny",
#         Principal = "*",
#         Action    = ["es:ESHttpDelete", "es:ESHttpPost", "es:ESHttpPut"],
#         Resource  = "${aws_elasticsearch_domain.default.arn}/*",
#       }
#     ]
#   })
# }

# resource "aws_elasticsearch_domain_policy" "default" {
#   domain_name     = "easyaws"
#   access_policies = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect    = "Allow",
#         Principal = {
#           AWS = "arn:aws:iam::921283598378:role/module.user_label.id"
#         },
#         Action    = [
#           "es:ESHttpDelete",
#           "es:ESHttpGet",
#           "es:ESHttpHead",
#           "es:ESHttpPost",
#           "es:ESHttpPut"
#         ],
#         Resource  = [
#           aws_elasticsearch_domain.default.arn,
#           "${aws_elasticsearch_domain.default.arn}/*"
#         ]
#       }
#     ]
#   })
# }

# data "aws_iam_policy_document" "default" {

#   statement {
#     actions = ["es:*", ]
#     resources = [
#       join("", aws_elasticsearch_domain.default.*.arn),
#       "${join("", aws_elasticsearch_domain.default.*.arn)}/*"
#     ]

#     principals {
#       type        = "AWS"
#       identifiers = ["*"]
#     }
#   }
# }

# resource "aws_elasticsearch_domain_policy" "default" {
#   domain_name     = "easyaws"
#   access_policies = join("", data.aws_iam_policy_document.default.*.json)
# }