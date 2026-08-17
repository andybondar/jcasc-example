data "aws_ami" "ubuntu" {
  most_recent = true
  region      = var.region

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  owners = ["amazon"]
}

data "aws_subnet" "main" {
  region = var.region
  filter {
    name   = "tag:Name"
    values = ["jcasc_subnet"]
  }
}

data "aws_security_group" "main" {
  name   = "jcasc_sg"
  region = var.region
}

data "aws_eip" "main" {
  region = var.region
  filter {
    name   = "tag:Name"
    values = ["jcasc_eip"]
  }
}

data "aws_ebs_volume" "main" {
  most_recent = true
  region      = var.region

  filter {
    name   = "tag:Name"
    values = ["jcasc_home_disk"]
  }
}