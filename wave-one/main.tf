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

module "cloudfront" {
  source                         = "./modules/cloudfront"
  periodic_table_bucket_endpoint = module.s3.periodic_table_bucket_endpoint
  certificate_arn                = var.certificate_arn
  frontend_domain                = var.frontend_domain
  tag                            = local.aws_tag
  env                            = var.env
}