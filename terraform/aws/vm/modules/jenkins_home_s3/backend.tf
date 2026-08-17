terraform {
  backend "s3" {
    bucket = "jcsac-tfstate-bucket-001"
    key    = "modules/jenkins_home_s3/terraform.tfstate"
    region = "eu-central-1"
  }
}