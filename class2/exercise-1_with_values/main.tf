
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.4.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}


variable "exercise_vpc_cidr" {
  type = string
}

variable "subnet_a_cidr" {
  type = string
}

variable "subnet_b_cidr" {
  type = string
}

resource "aws_vpc" "exercise_vpc" {
  cidr_block = var.exercise_vpc_cidr

  tags = {
    Name = "tf-vpc-1"
  }
}

resource "aws_subnet" "subnet_a" {
  vpc_id     = aws_vpc.exercise_vpc.id
  cidr_block = var.subnet_a_cidr

  tags = {
    Name = "tf-subnet-a"
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id     = aws_vpc.exercise_vpc.id
  cidr_block = var.subnet_b_cidr

  tags = {
    Name = "tf-subnet-b"
  }
}

