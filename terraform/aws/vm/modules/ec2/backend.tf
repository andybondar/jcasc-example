terraform {
  backend "s3" {
    bucket = "jcsac-tfstate-bucket-001"
    key    = "terraform/aws/vm/modules/ec2/terraform.tfstate"
    region = "eu-central-1"
  }
}