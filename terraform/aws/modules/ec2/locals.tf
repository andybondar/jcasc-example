locals {
  ec2_tags = merge(
    var.tags,
    {
      Name = "jcasc_ec2"
    }
  )

  disk_tags = merge(
    var.tags,
    {
      Name = "jcasc_ec2_disk"
    }
  )
}