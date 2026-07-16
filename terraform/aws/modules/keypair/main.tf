resource "aws_key_pair" "main" {
  key_name   = local.keypair_tags["Name"]
  public_key = file(var.public_key_path)
  region     = var.region

  tags = local.keypair_tags
}