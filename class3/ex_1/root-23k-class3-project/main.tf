module "bastion23k" {
  source       = "../module-bastion"
  ec2_type     = "t3.micro"
  sg_name      = "23k-bastion-sg"
  ec2_tag_name = "bastion23k"
}

module "bastion-strong" {
  source       = "../module-bastion"
  ec2_type     = "t3.medium"
  sg_name      = "strong_bastion"
  ec2_tag_name = "Strong Bastion"
}

module "webserver" {
  source = "../module-webserver"
}
