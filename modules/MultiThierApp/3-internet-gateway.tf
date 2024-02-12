/* -------------------------------------------------------------------------- */
/*                               INTERNET GATEWAY                   */
/* -------------------------------------------------------------------------- */

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_prod.id
  tags   = merge(var.tags, {})
}