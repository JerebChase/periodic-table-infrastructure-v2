output "ecr_repository_url" {
    description = "The url for the ecr repository"
    value       = aws_ecr_repository.periodic_table_repo.repository_url
}

output "codebuild_run" {
  description = "The codebuild run resource that pushes a temp image to ECR"
  value       = null_resource.trigger_codebuild 
}