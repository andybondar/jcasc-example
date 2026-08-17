locals {
    tags = merge(
    var.tags,
    {
      Name = "jcasc_home_disk"
    }
  )  

  snapshot_id = try(data.aws_ebs_snapshot.jenkins_home[0].id, null)
}