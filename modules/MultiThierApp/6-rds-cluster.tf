resource "aws_rds_cluster" "aws_rds_cluster_prod_primary" {
  tags                 = merge(var.tags, {})
  engine               = "aurora-postgresql"
  db_subnet_group_name = aws_db_subnet_group.aws_db_private_subnet_group.name
  master_username      = "franroav"
  master_password      = "franroav_password"
  # allocated_storage    = 0 # Set to 0 or remove this line
  # storage_type         = "io2"  # Choose either "io2" or "standard"
  engine_version       = "11.9" # Use a valid Aurora PostgreSQL version available in your AWS region
  skip_final_snapshot  = true
  # final_snapshot_identifier = "my-final-snapshot"  # Specify a meaningful name for the final snapshot
  availability_zones = [
    "us-east-1a",
    "us-east-1b",
  ]
}

resource "aws_rds_cluster" "aws_rds_cluster_prod_standby" {
  tags                 = merge(var.tags, {})
  engine               = "aurora-postgresql"
  db_subnet_group_name = aws_db_subnet_group.aws_db_private_subnet_group.name
  master_username      = "franroav"
  master_password      = "franroav_password"
  # allocated_storage    = 0 # Set to 0 or remove this line
  # storage_type         = "io2"  # Choose either "io2" or "standard"
  engine_version       = "11.9" # Use a valid Aurora PostgreSQL version available in your AWS region
  skip_final_snapshot  = true   # this should be 'false' for backup recovery needs
  # final_snapshot_identifier = "my-final-snapshot"  # Specify a meaningful name for the final snapshot
  availability_zones = [
    "us-east-1a",
    "us-east-1b",
  ]
}



# For example, SQL Server Standard Edition on db.m5.xlarge has a default allocated storage for the instance of 20 GiB (the minimum) and a maximum 
# allocated storage of 16,384 GiB. The default maximum storage threshold for autoscaling is 1,000 GiB. If you use this default, the instance doesn't 
# autoscale above 1,000 GiB. This is true even though the maximum allocated storage for the instance is 16,384 GiB.
