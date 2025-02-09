output "apprunner_build_role" {
    description = "The arn of the apprunner build role"
    value       = module.iam.apprunner_build_role
}

output "apprunner_execution_role" {
    description = "The arn of the apprunner execution role"
    value       = module.iam.apprunner_execution_role
}

output "ecr_repository_url" {
    description = "The url for the ecr repository"
    value       = module.ecr.ecr_repository_url
}

output "frontend_domain_target" {
  description = "The domain record for the cloudfront distribution"
  value       = module.cloudfront.frontend_domain_target
}