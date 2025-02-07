output "periodic_table_service_url" {
  description = "The url of the periodic table apprunner service"
  value        = aws_apprunner_service.periodic_table_service.service_url
}

# output "certificate_validation_records" {
#   description = "The list of certificate validation records for the app runner custom domain"
#   value       = aws_apprunner_custom_domain_association.periodic_table_api_domain.certificate_validation_records
# }

# output "backend_domain_target" {
#   description = "The domain record for the apprunner service"
#   value       = aws_apprunner_custom_domain_association.periodic_table_api_domain.dns_target
# }