resource "aws_db_instance" "mysql-db" {
  identifier           = "sampledb"
  instance_class       = var.ec2_type
  allocated_storage    = 15
  engine               = "mysql"
  engine_version       = "5.7"
  username             = "user"
  password             = var.password
  parameter_group_name = "default.mysql5.7"
  publicly_accessible  = true
  skip_final_snapshot  = true
}


variable "ec2_type" {
  type = string
}

variable "password" {
  type = string

}
