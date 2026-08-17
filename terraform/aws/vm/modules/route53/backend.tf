terraform {
  backend "s3" {
    bucket = "jcsac-tfstate-bucket-001"
    key    = "modules/route53/terraform.tfstate"
    region = "eu-central-1"
  }
}