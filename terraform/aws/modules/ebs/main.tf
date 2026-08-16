resource "aws_ebs_volume" "main" {
  availability_zone = var.az
  size              = local.snapshot_id == null ? var.disk_size : null
  encrypted         = true
  snapshot_id       = local.snapshot_id

  tags = local.tags

  final_snapshot = true
}