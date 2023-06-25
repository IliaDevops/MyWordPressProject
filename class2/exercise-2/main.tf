
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

resource "aws_instance" "bastion" {
  ami                    = "ami-022e1a32d3f742bd8"
  instance_type          = "t3.micro"
  key_name               = "linuxkey"
  vpc_security_group_ids = [aws_security_group.allow_ssh_sg.id]
  subnet_id              = aws_subnet.subnet_a.id

  tags = {
    Name = "BastionHost"
  }
}

resource "aws_security_group" "allow_ssh_sg" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.exercise_vpc.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = "allow_ssh security group"
  }
}
