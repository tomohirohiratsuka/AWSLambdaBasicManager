variable "app_name" {
    description = "The name of the application"
    default     = "my-app"
}

variable "env" {
    description = "The environment for the application"
    default     = "development"
}

variable "env_short" {
    description = "The short name of the environment"
    default     = "dev"
}

variable "aws_region" {
  description = "AWS region"
  default     = "ap-northeast-1"
}

variable "domain_name" {
  description = "The domain name for the Route 53 hosted zone"
}

variable "subdomain_name" {
  description = "The subdomain name for the ALB"
  default     = "lambda"
}

variable "lambda_function_name" {
  description = "The name of the Lambda function"
  default     = "my-lambda-function"
}

variable "lambda_handler" {
  description = "The handler of the Lambda function"
  default     = "index.handler"
}

variable "lambda_runtime" {
  description = "The runtime of the Lambda function"
  default     = "nodejs20.x"
}

variable "lambda_source_dir" {
  description = "The local directory of the Lambda function code"
  default     = "./lambda_function"
}

variable "vpc_cidr_block" {
    description = "The CIDR block of the VPC"
    default     = "192.168.0.0/16"
}

variable "availability_zone_1a" {
    description = "The availability zone for 1a of the VPC"
}

variable "availability_zone_1c" {
    description = "The availability zone for 1c of the VPC"
}

variable "public_subnet_cidr_block_1a" {
    description = "The CIDR block of the public subnet for 1a"
    default     = "192.168.0.0/24"
}

variable "public_subnet_cidr_block_1c" {
  description = "The CIDR block of the public subnet for 1c"
    default     = "192.168.1.0/24"
}






