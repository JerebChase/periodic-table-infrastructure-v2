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

locals {
  aws_tag = "periodic-table-${var.env}"
}

provider "aws" {
  region = "us-east-1"
}

provider "cloudflare" { }

module "rg" {
  source = "./modules/rg"
  tag    = local.aws_tag
  env    = var.env
}

module "s3" {
  source = "./modules/s3"
  tag    = local.aws_tag
  env    = var.env
}

module "db" {
  source                   = "./modules/db"
  tag                      = local.aws_tag
  env                      = var.env
  periodic_table_s3_bucket = module.s3.periodic_table_s3_bucket
}

module "iam" {
  source                = "./modules/iam"
  tag                   = local.aws_tag
  env                   = var.env
  periodic_table_db_arn = module.db.periodic_table_db_arn
}

module "ecr" {
  source           = "./modules/ecr"
  codebuild_role   = module.iam.codebuild_role
  tag              = local.aws_tag
  env              = var.env
}

module "apprunner" {
source                     = "./modules/apprunner"
  apprunner_build_role     = module.iam.apprunner_build_role
  apprunner_execution_role = module.iam.apprunner_execution_role
  ecr_repository_url       = module.ecr.ecr_repository_url
  backend_domain           = var.backend_domain 
  codebuild_run            = module.ecr.codebuild_run
  tag                      = local.aws_tag
  env                      = var.env
}

module "cloudfront" {
  source                         = "./modules/cloudfront"
  periodic_table_bucket_endpoint = module.s3.periodic_table_bucket_endpoint
  certificate_arn                = var.certificate_arn
  frontend_domain                = var.frontend_domain
  tag                            = local.aws_tag
  env                            = var.env
}

module "cloudflare" {
  source                         = "./modules/cloudflare"
  zone_id                        = var.zone_id
  certificate_validation_records = module.apprunner.certificate_validation_records
  # backend_domain_target          = module.apprunner.backend_domain_target
  # backend_domain                 = var.backend_domain
  frontend_domain_target         = module.cloudfront.frontend_domain_target
  frontend_domain                = var.frontend_domain
  env                            = var.env
}