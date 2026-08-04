locals {
    tags = merge(
    var.tags,
    {
      Name = "jcasc_home_disk"
    }
  )  
}