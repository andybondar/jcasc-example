variable "ecr_repositories" {
  type = list(string)
  description = "ECR repositories"
  default = [
    "jenkins"
  ]
}