resource "aws_ecr_repository" "main" {
  count = length(var.ecr_repositories)
  name = var.ecr_repositories[count.index]
  region = var.region
  force_delete = true
}