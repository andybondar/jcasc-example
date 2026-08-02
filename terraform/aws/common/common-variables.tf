variable "tags" {
  type        = any
  description = "Tags"
  default = {
    Project = "jenkins-as-code-project"
  }
}

variable "tfstate_bucket" {
  type        = string
  description = "Terraform State bucket name"
  default     = "jcsac-tfstate-bucket-001"
}

variable "region" {
  type        = string
  description = "Default region"
  default     = "eu-central-1"
}

variable "az" {
  type = string
  description = "Availability zone for EBS and EC2"
  default = "eu-central-1a"
}