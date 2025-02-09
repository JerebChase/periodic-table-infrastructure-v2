resource "aws_apprunner_auto_scaling_configuration_version" "periodic_table_scaling_config" {
  auto_scaling_configuration_name = "periodic-table-scaling-${var.env}"
  min_size                        = 1
  max_size                        = 5
  max_concurrency                 = 10

  tags = {
    env = "${var.tag}"
  }
}

resource "aws_apprunner_service" "periodic_table_service" {
  service_name = "periodic-table-service-${var.env}"

  source_configuration {
    authentication_configuration {
      access_role_arn = var.apprunner_build_role
    }

    image_repository {
      image_identifier      = "${var.ecr_repository_url}:latest"
      image_repository_type = "ECR"
      image_configuration {
        port = 8080
      }
    }
  }

  instance_configuration {
    instance_role_arn = var.apprunner_execution_role
    cpu    = "0.25 vCPU"
    memory = "512"
  }

  auto_scaling_configuration_arn = aws_apprunner_auto_scaling_configuration_version.periodic_table_scaling_config.arn

  tags = {
    env = "${var.tag}"
  }
}

resource "aws_apprunner_custom_domain_association" "periodic_table_api_domain" {
  domain_name = var.backend_domain
  service_arn = aws_apprunner_service.periodic_table_service.arn
}