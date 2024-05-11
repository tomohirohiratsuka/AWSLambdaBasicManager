####################################################
# VPC
####################################################

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
}

####################################################
# Public Subnet
####################################################

resource "aws_subnet" "public_1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr_block_1a
  availability_zone = var.availability_zone_1a
}

resource "aws_subnet" "public_1c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr_block_1c
  availability_zone = var.availability_zone_1c
}