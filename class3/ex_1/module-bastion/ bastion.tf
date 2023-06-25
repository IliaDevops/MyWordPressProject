
resource "aws_instance" "bastion" {
  ami                    = "ami-022e1a32d3f742bd8"
  instance_type          = var.ec2_type
  key_name               = "linuxkey"
  vpc_security_group_ids = [aws_security_group.allow_ssh_sg.id]


  tags = {
    Name = var.ec2_tag_name
  }
}

resource "aws_security_group" "allow_ssh_sg" {
  name        = var.sg_name
  description = "Allow SSH inbound traffic"
  # vpc_id      = aws_vpc.exercise_vpc.id

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

variable "ec2_type" {
  type = string

}

variable "sg_name" {
  type = string

}

variable "ec2_tag_name" {
  type = string

}
