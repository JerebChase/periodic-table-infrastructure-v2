terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}

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

  depends_on = [ var.codebuild_run ]
}

resource "aws_apprunner_custom_domain_association" "periodic_table_api_domain" {
  domain_name = var.backend_domain
  service_arn = aws_apprunner_service.periodic_table_service.arn
}

resource "cloudflare_dns_record" "certificate_record" {
  for_each = {
    for record in flatten(aws_apprunner_custom_domain_association.periodic_table_api_domain.certificate_validation_records) :
    record.name => record
  }

  zone_id  = var.zone_id
  name     = each.value.name
  content  = each.value.value
  type     = each.value.type
  ttl      = 300
  comment  = "Validation record for app runner custom domain"
}

resource "cloudflare_dns_record" "backend_domain_record" {
  zone_id = var.zone_id
  name    = var.backend_domain
  content = aws_apprunner_custom_domain_association.periodic_table_api_domain.dns_target
  type    = "CNAME"
  ttl     = 300
}
