resource "aws_ebs_volume" "main" {
  availability_zone = var.az
  size              = var.disk_size
  encrypted         = true

  tags = local.tags

  final_snapshot = true
}