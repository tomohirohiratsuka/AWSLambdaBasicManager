# About
This is a repository for create lambda function infrastructure using terraform and lambda functions.

# Prerequisites
You should configure your AWS profile in your local machine. You can do this by running the following command:
```bash
aws configure --profile <PROFILE_NAME>
```
Set variables in `terraform/env/local/main.tf` file.
```hcl
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
```
`lambda_source_dir` is the path to the lambda function code. You can change it to your own path.
In the example code, since it's written in TypeScript, the code is compiled to the `dist` directory.
So, the path is `../../../lambda/exampleFunction/dist`.

# Usage
1. Clone the repository.
2. Set variables in `terraform/env/local/main.tf` file.
3. Run the following commands:
```bash
cd terraform/env/local
terraform init
terraform plan
terraform apply
```
Then, terraform make zip file from specified directory and create lambda function and infrastructure.


