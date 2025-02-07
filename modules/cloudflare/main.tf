terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}

locals {
  certificate_validation_map = {
    for record in var.certificate_validation_records :
    record.name => record
  }
}

resource "cloudflare_dns_record" "certificate_record" {
  for_each = local.certificate_validation_map

  zone_id = var.zone_id
  name    = each.value.name
  content = each.value.value
  type    = "CNAME"
  ttl     = 300
  comment = "Validation record for app runner custom domain"
}

resource "cloudflare_dns_record" "backend_domain_record" {
  zone_id = var.zone_id
  name    = var.backend_domain
  content = var.backend_domain_target
  type    = "CNAME"
  ttl     = 300
}

resource "cloudflare_dns_record" "frontend_domain_record" {
  zone_id = var.zone_id
  name    = var.frontend_domain
  content = var.frontend_domain_target
  type    = "CNAME"
  ttl     = 300
}