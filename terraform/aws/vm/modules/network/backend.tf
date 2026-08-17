terraform {
  backend "s3" {
    bucket = "jcsac-tfstate-bucket-001"
    key    = "terraform/aws/vm/modules/network/terraform.tfstate"
    region = "eu-central-1"
  }
}