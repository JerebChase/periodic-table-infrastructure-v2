resource "aws_apigatewayv2_api" "periodic_table_api_gateway" {
  name          = "periodic-table-apigw-${var.env}"
  protocol_type = "HTTP"
  cors_configuration {
    allow_origins = [var.frontend_domain]
    allow_methods = ["GET", "POST", "OPTIONS"]
    allow_headers = ["Content-Type", "Authorization"]
  }

  tags = {
    env = "${var.tag}"
  }
}

resource "aws_apigatewayv2_integration" "apprunner_integration" {
  api_id           = aws_apigatewayv2_api.periodic_table_api_gateway.id
  integration_type = "HTTP_PROXY"
  integration_method = "ANY"
  integration_uri = "https://${var.apprunner_url}"
  payload_format_version = "1.0"
}

resource "aws_apigatewayv2_route" "proxy_route" {
  api_id    = aws_apigatewayv2_api.periodic_table_api_gateway.id
  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.apprunner_integration.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.periodic_table_api_gateway.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_domain_name" "custom_domain" {
  domain_name = var.backend_domain

  domain_name_configuration {
    certificate_arn = var.certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_apigatewayv2_api_mapping" "custom_domain_mapping" {
  api_id      = aws_apigatewayv2_api.periodic_table_api_gateway.id
  domain_name = aws_apigatewayv2_domain_name.custom_domain.id
  stage       = aws_apigatewayv2_stage.default.id
}