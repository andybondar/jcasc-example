locals {
  eip_tags = merge(
    var.tags,
    {
      Name = "jcasc_eip"
    }
  )
}