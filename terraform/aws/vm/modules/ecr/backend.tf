terraform {
  backend "s3" {
    bucket = "jcsac-tfstate-bucket-001"
    key    = "modules/ecr/terraform.tfstate"
    region = "eu-central-1"
  }
}