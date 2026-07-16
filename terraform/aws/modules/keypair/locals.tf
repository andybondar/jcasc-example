locals {
  keypair_tags = merge(
    var.tags,
    {
      Name = "jcasc_keypair"
    }
  )  
}