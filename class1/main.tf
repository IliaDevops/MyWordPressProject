

variable "image_id" {
  type    = string
  default = "ami-022e1a32d3f742bd8"

}

variable "http_sg_id" {
  type    = string
  default = "sg-0652bff21adf4b8fe"

}

variable "ec2_type" {
  type    = string
  default = "t2.micro"

}

resource "aws_instance" "ec2_type" {
  ami                    = var.image_id
  instance_type          = var.ec2_type
  vpc_security_group_ids = [var.http_sg_id]

  tags = {
    Name = "MyWebServer"
  }
}


