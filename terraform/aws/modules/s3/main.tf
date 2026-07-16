resource "aws_s3_bucket" "main" {
  bucket = var.tfstate_bucket
  region = var.region

  tags = var.tags
  force_destroy = true
}