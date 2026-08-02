resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  region     = var.region

  tags = local.vpc_tags
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  region            = var.region
  cidr_block        = var.subnet["cidr"]
  availability_zone = var.az

  tags = local.subnet_tags
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  region = var.region

  tags = local.igw_tags
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
  region = var.region

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = local.rtable_tags
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
  region         = var.region
}