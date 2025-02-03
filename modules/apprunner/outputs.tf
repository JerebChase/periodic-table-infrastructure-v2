output "periodic_table_service_url" {
  description = "The url of the periodic table apprunner service"
  value        = aws_apprunner_service.periodic_table_service.service_url
}