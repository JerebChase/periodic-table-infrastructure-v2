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

module "rg" {
  source = "./modules/rg"
  tag    = local.aws_tag
  env    = var.env
}

module "ecr" {
  source = "./modules/ecr"
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

module "apprunner" {
source                   = "./modules/apprunner"
  apprunner_role_arn     = module.iam.apprunner_execution_role
  ecr_repository_url     = module.ecr.ecr_repository_url
  tag                    = local.aws_tag
  env                    = var.env
}

module "apigw" {
  source                     = "./modules/apigw"
  periodic_table_service_url = module.apprunner.periodic_table_service_url
  tag                        = local.aws_tag
  env                        = var.env
}

# module "cloudfront" {
#   source                         = "./modules/cloudfront"
#   periodic_table_bucket_endpoint = module.s3.periodic_table_bucket_endpoint
#   certificate_arn                = var.certificate_arn
#   frontend_domain                = var.frontend_domain
#   tag                            = local.aws_tag
#   env                            = var.env
# }