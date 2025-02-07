terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}

resource "cloudflare_dns_record" "certificate_record" {
  count   = length(toList(var.certificate_validation_records))

  zone_id = var.zone_id
  name    = toList(var.certificate_validation_records)[count.index].name
  content = toList(var.certificate_validation_records)[count.index].value
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