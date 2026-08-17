locals {
    vpc_tags = merge(
    var.tags,
    {
      Name = "jcasc_vpc"
    }
  )

  subnet_tags = merge(
    var.tags,
    {
      Name = var.subnet["name"]
    }
  )

  igw_tags = merge(
    var.tags,
    {
      Name = "jcasc_igw"
    }
  )

  rtable_tags = merge(
    var.tags,
    {
      Name = "jcasc_rtable"
    }
  )

  sg_tags = merge(
    var.tags,
    {
      Name = "jcasc_sg"
    }
  ) 
}