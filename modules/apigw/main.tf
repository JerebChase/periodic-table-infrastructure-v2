resource "aws_apigatewayv2_api" "periodic_table_api" {
  name          = "periodic-table-api-${var.env}"
  protocol_type = "HTTP"

  tags = {
    env = "${var.tag}"
  }
}

resource "aws_apigatewayv2_integration" "periodic_table_api_integration" {
  api_id             = aws_apigatewayv2_api.periodic_table_api.id
  integration_type   = "HTTP_PROXY"
  integration_uri    = var.periodic_table_service_url
}

resource "aws_apigatewayv2_route" "proxy_route" {
  api_id    = aws_apigatewayv2_api.periodic_table_api.id
  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.periodic_table_api_integration.id}"
}