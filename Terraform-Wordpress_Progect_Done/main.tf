# Variables
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



variable "aws_region" {
  default = "us-east-1"
}

variable "ami_id" {
  default = "ami-090e0fc566929d98b" # Replace with the desired Amazon Linux 2 AMI ID
}

variable "ingress_ports" {
  default = [22, 80, 443] # SSH, HTTP, HTTPS ports
}

# Create VPC
resource "aws_vpc" "wordpress_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "wordpress-vpc"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "wordpress_igw" {
  vpc_id = aws_vpc.wordpress_vpc.id
  tags = {
    Name = "wordpress_igw"
  }
}

# Create Route Table
resource "aws_route_table" "wordpress_rt" {
  vpc_id = aws_vpc.wordpress_vpc.id
  tags = {
    Name = "wordpress-rt"
  }
}


resource "aws_route_table_association" "associate_public1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.wordpress_rt.id
}

resource "aws_route_table_association" "associate_public2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.wordpress_rt.id
}

resource "aws_route_table_association" "associate_public3" {
  subnet_id      = aws_subnet.public_subnet_3.id
  route_table_id = aws_route_table.wordpress_rt.id
}



# Create Internet Gateway Route
resource "aws_route" "wordpress_rt_igw" {
  route_table_id         = aws_route_table.wordpress_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.wordpress_igw.id
}

# Create Subnets
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.wordpress_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.wordpress_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-2"
  }
}

resource "aws_subnet" "public_subnet_3" {
  vpc_id                  = aws_vpc.wordpress_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "${var.aws_region}c"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-3"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.wordpress_vpc.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "${var.aws_region}a"
  tags = {
    Name = "private-subnet-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.wordpress_vpc.id
  cidr_block        = "10.0.12.0/24"
  availability_zone = "${var.aws_region}b"
  tags = {
    Name = "private-subnet-2"
  }
}

resource "aws_subnet" "private_subnet_3" {
  vpc_id            = aws_vpc.wordpress_vpc.id
  cidr_block        = "10.0.13.0/24"
  availability_zone = "${var.aws_region}c"
  tags = {
    Name = "private-subnet-3"
  }
}

# Create Security Group for WordPress
resource "aws_security_group" "wordpress_sg" {
  name        = "wordpress-sg"
  description = "Allow SSH, HTTP, HTTPS inbound traffic"
  vpc_id      = aws_vpc.wordpress_vpc.id

  ingress {
    description = "SSH from anywhere"
    from_port   = var.ingress_ports[0]
    to_port     = var.ingress_ports[0]
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from anywhere"
    from_port   = var.ingress_ports[1]
    to_port     = var.ingress_ports[1]
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from anywhere"
    from_port   = var.ingress_ports[2]
    to_port     = var.ingress_ports[2]
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
    Name = "wordpress-sg"
  }
}

#Create Key Pair



#resource "aws_key_pair" "TF_key" {
#  key_name   = "TF_key"
#  public_key = tls_private_key.rsa.public_key_openssh

##resource "tls_private_key" "rsa" {
#  algorithm = "RSA"
#  rsa_bits  = 4096
#}

#resource "local_file" "TF_key" {
#  content  = tls_private_key.rsa.private_key_pem
#  filename = "TF_key"
#}


# Create EC2 Instance
resource "aws_instance" "wordpress_ec2" {
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  key_name               = "linuxkey"
  subnet_id              = aws_subnet.public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.wordpress_sg.id]
  tags = {
    Name = "wordpress-ec2"

  }
}

# Create Security Group for RDS
resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Allow TCP to MySQL inbound traffic"
  vpc_id      = aws_vpc.wordpress_vpc.id

  ingress {
    description     = "TCP from WordPress security group"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.wordpress_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg"
  }
}

# Create RDS DB Instance
resource "aws_db_instance" "mysql" {

  allocated_storage      = 20
  db_name                = "sampledb"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  username               = "admin"
  password               = "adminadmin"
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.mysql_db_subnet.id
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  tags = {
    Name = "Mysql"
  }
}

# Create DB Subnet Group
resource "aws_db_subnet_group" "mysql_db_subnet" {
  name        = "mysql-subnet-group"
  description = "Subnet group for RDS MySQL instance"
  subnet_ids  = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id, aws_subnet.private_subnet_3.id]

}

