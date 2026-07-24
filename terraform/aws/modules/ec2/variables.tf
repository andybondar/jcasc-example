variable "ec2_instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.small"
}

variable "ec2_disk_size" {
  type        = number
  description = "EC2 disk size"
  default     = 20
}

variable "aws_account" {
  type        = string
  description = "AWS account"
}