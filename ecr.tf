resource "aws_ecr_repository" "docker-ecr-ap-python-image" {
  name = "docker-ecr-ap-python-image"
  tags = merge(
    local.common_tags,
    { DockerHub : "dwpdigital/docker-ecr-ap-python-image" }
  )
}

resource "aws_ecr_repository_policy" "docker-ecr-ap-python-image" {
  repository = aws_ecr_repository.docker-ecr-ap-python-image.name
  policy     = data.terraform_remote_state.management.outputs.ecr_iam_policy_document
}

output "ecr_docker-ecr-ap-python-image_url" {
  value = aws_ecr_repository.docker-ecr-ap-python-image.repository_url
}
