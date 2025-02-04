resource "aws_apprunner_auto_scaling_configuration_version" "periodic_table_scaling_config" {
  auto_scaling_configuration_name = "periodic-table-scaling-config-${var.env}"
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
      access_role_arn = var.apprunner_role_arn
    }

    image_repository {
      image_identifier      = var.ecr_repository_url
      image_repository_type = "ECR"
    }
  }

  instance_configuration {
    cpu    = "0.25 vCPU"
    memory = "512 MB"
  }

  auto_scaling_configuration_arn = aws_apprunner_auto_scaling_configuration_version.periodic_table_scaling_config.arn

  tags = {
    env = "${var.tag}"
  }
}