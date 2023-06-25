module "app-with-db-root" {
  source   = "../rds-mysql"
  ec2_type = "db.t3.micro"
  password = "INCREDIBLE"

}

module "app-with-db-1" {
  source   = "../iam-user"
  iam-user = "alice"

}

module "app-with-db-2" {
  source   = "../iam-user"
  iam-user = "john"

}
