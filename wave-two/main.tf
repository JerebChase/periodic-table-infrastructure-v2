terraform {
  cloud {
    organization = "jeremy-chase-brown"
  }
}

locals {
  aws_tag = "periodic-table-${var.env}"
}

provider "aws" {
  region = "us-east-1"
}

data "terraform_remote_state" "wave_one" {
  backend = "remote"
  config = {
    organization = "jeremy-chase-brown"
    workspaces = {
      name = "wave-one-periodic-table-infrastructure-${var.env}"
    }
  }
}

module "apprunner" {
source                     = "./modules/apprunner"
  apprunner_build_role     = data.terraform_remote_state.wave_one.outputs.apprunner_build_role
  apprunner_execution_role = data.terraform_remote_state.wave_one.outputs.apprunner_execution_role
  ecr_repository_url       = data.terraform_remote_state.wave_one.outputs.ecr_repository_url
  backend_domain           = var.backend_domain
  tag                      = local.aws_tag
  env                      = var.env
}
