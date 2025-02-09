output "certificate_validation_records" {
  description = "The list of certificate validation records for the app runner custom domain"
  value       = module.apprunner.certificate_validation_records
}

output "backend_domain_target" {
  description = "The domain record for the apprunner service"
  value       = module.apprunner.backend_domain_target
}

output "frontend_domain_target" {
  description = "The domain record for the cloudfront distribution"
  value       = data.terraform_remote_state.wave_one.outputs.frontend_domain_target
}