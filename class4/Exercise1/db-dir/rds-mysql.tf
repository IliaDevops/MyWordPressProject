resource "aws_db_instance" "exercise_db" {

  allocated_storage    = 15
  db_name              = "sampledb"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = "INCREDIBLE"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}


output "db_arn" {
  value = aws_db_instance.exercise_db.arn

}

output "instance_name" {
  value = aws_db_instance.exercise_db.identifier

}
