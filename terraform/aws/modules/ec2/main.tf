resource "aws_instance" "main" {
  ami                    = data.aws_ami.ubuntu.id
  region                 = var.region
  instance_type          = var.ec2_instance_type
  key_name               = "jcasc_keypair"
  subnet_id              = data.aws_subnet.main.id
  vpc_security_group_ids = [data.aws_security_group.main.id]
  user_data = templatefile("install_jenkins.tftpl", {
    aws_account     = var.aws_account
    compose_content = file("docker-compose.yaml")
  })

  root_block_device {
    encrypted   = true
    volume_size = var.ec2_disk_size

    tags = local.disk_tags
  }

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  tags = local.ec2_tags
}

resource "aws_volume_attachment" "main" {
  device_name = "/dev/xvdbb"
  volume_id   = data.aws_ebs_volume.main.id
  instance_id = aws_instance.main.id
}

resource "aws_eip_association" "main" {
  region        = var.region
  instance_id   = aws_instance.main.id
  allocation_id = data.aws_eip.main.id
}