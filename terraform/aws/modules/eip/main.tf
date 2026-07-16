resource "aws_eip" "main" {
  region = var.region
  tags   = local.eip_tags
}