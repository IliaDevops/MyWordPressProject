resource "aws_instance" "webserver" {
  ami                    = "ami-022e1a32d3f742bd8"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [var.launch_sg_id]
  subnet_id              = var.launch_subnet_id

  tags = {
    Name = "HelloWorld"
  }
}
variable "launch_subnet_id" {
  type = string

}

variable "launch_sg_id" {
  type = string
}
