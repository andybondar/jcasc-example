variable "vpc_cidr_block" {
  type        = string
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"
}

variable "subnet" {
  type        = any
  description = "Subnet"
  default = {
    cidr = "10.0.0.0/24"
    name = "jcasc_subnet"
    az   = "eu-central-1a"
  }
}

variable "allow_all_traffic" {
  type        = any
  description = "Allow ALL IPv4 outbound tarffic"
  default = {
    enable      = true
    cidr_ipv4   = "0.0.0.0/0"
    ip_protocol = "-1"
  }
}

variable "allow_ssh" {
  type        = any
  description = "Allow SSH inbound tarffic"
  default = {
    enable      = true
    cidr_ipv4   = "0.0.0.0/0"
    ip_protocol = "tcp"
    from_port   = 22
    to_port     = 22
  }
}

variable "allow_http" {
  type        = any
  description = "Allow HTTP inbound tarffic"
  default = {
    enable      = true
    cidr_ipv4   = "0.0.0.0/0"
    ip_protocol = "tcp"
    from_port   = 80
    to_port     = 80
  }
}