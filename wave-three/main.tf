terraform {
  cloud {
    organization = "jeremy-chase-brown"
  }
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
  }
}

provider "cloudflare" { }

data "terraform_remote_state" "wave_two" {
  backend = "remote"
  config = {
    organization = "jeremy-chase-brown"
    workspaces = {
      name = "wave-two-periodic-table-infrastructure-${var.env}"
    }
  }
}

module "cloudflare" {
  source                         = "./modules/cloudflare"
  zone_id                        = var.zone_id
  certificate_validation_records = data.terraform_remote_state.wave_two.outputs.certificate_validation_records
  backend_domain_target          = data.terraform_remote_state.wave_two.outputs.backend_domain_target
  backend_domain                 = var.backend_domain
  frontend_domain_target         = data.terraform_remote_state.wave_two.outputs.frontend_domain_target
  frontend_domain                = var.frontend_domain
  env                            = var.env
}
