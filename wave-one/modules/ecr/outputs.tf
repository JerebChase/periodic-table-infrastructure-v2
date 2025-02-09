output "ecr_repository_url" {
    description = "The url for the ecr repository"
    value       = aws_ecr_repository.periodic_table_repo.repository_url
}