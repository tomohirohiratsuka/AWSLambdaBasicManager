################################################
## Locals
################################################
locals {
  aws_profile   = "YOUR_AWS_PROFILE_NAME"
  aws_region    = "ap-northeast-1"
  app_name      = "YOUR_APP_NAME"
  app_env       = "local"
  app_env_short = "local"
}

################################################
## Required Providers
################################################
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0"
    }
  }
}

################################################
## Provider Configuration
################################################
provider "aws" {
  region  = local.aws_region
  profile = local.aws_profile
}

################################################
## Module
################################################
module "modules" {
  source                      = "../../modules"
  app_name                    = local.app_name
  env                         = local.app_env
  env_short                   = local.app_env_short
  domain_name                 = "YOUR_DOMAIN_NAME"
  subdomain_name              = "YOUR_SUBDOMAIN_NAME"
  aws_region                  = local.aws_region
  lambda_function_name        = local.app_name
  lambda_handler              = "index.handler"
  lambda_runtime              = "nodejs20.x"
  lambda_source_dir           = "../../../lambda/exampleFunction/dist"
  vpc_cidr_block              = "192.168.0.0/16"
  availability_zone_1a        = "${local.aws_region}a"
  availability_zone_1c        = "${local.aws_region}c"
  public_subnet_cidr_block_1a = "192.168.0.0/24"
  public_subnet_cidr_block_1c = "192.168.1.0/24"
}