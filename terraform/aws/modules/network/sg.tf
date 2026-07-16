resource "aws_security_group" "main" {
  name        = local.sg_tags["Name"]
  description = "Allow SSH and HTTP inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id
  region      = var.region

  tags = local.sg_tags
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
  count             = var.allow_all_traffic["enable"] ? 1 : 0
  security_group_id = aws_security_group.main.id
  region            = var.region

  cidr_ipv4   = var.allow_all_traffic["cidr_ipv4"]
  ip_protocol = var.allow_all_traffic["ip_protocol"]
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  count             = var.allow_ssh["enable"] ? 1 : 0
  security_group_id = aws_security_group.main.id
  region            = var.region

  cidr_ipv4   = var.allow_ssh["cidr_ipv4"]
  from_port   = var.allow_ssh["from_port"]
  to_port     = var.allow_ssh["to_port"]
  ip_protocol = var.allow_ssh["ip_protocol"]
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  count             = var.allow_http["enable"] ? 1 : 0
  security_group_id = aws_security_group.main.id
  region            = var.region

  cidr_ipv4   = var.allow_http["cidr_ipv4"]
  from_port   = var.allow_http["from_port"]
  to_port     = var.allow_http["to_port"]
  ip_protocol = var.allow_http["ip_protocol"]
}