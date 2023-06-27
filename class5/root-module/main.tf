module "web_server" {
  source  = "../ec2-module"
  webtype = var.ec2_type
}

