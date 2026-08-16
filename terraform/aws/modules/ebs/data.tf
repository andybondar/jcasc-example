data "aws_ebs_snapshot_ids" "jenkins_home" {
  filter {
    name   = "tag:Name"
    values = ["jcasc_home_disk"]
  }
}

data "aws_ebs_snapshot" "jenkins_home" {
  count = length(data.aws_ebs_snapshot_ids.jenkins_home.ids) > 0 ? 1 : 0

  most_recent  = true
  snapshot_ids = data.aws_ebs_snapshot_ids.jenkins_home.ids
}
