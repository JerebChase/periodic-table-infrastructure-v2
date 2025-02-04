output "api_gateway_url" {
  description = "The invoke url of the periodic table api gateway"
  value       = aws_apigatewayv2_api.periodic_table_api_gateway.api_endpoint
}