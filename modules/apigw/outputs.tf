output "periodic_table_api" {
    description = "The api id for the periodic table api"
    value       = aws_apigatewayv2_api.periodic_table_api.id
}