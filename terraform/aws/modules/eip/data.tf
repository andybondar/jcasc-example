data "aws_route53_zone" "main" {
  name         = var.domain
  private_zone = false
}