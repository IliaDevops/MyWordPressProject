module "sg" {
  source             = "../sg-module"
  destination_vpc_id = module.vpc.vpc_id
}
module "vpc" {
  source = "../vpc-module"
}
module "ec2" {
  count            = 3
  source           = "../ec2-module"
  launch_subnet_id = module.vpc.subnet_one
  launch_sg_id     = module.sg.sg_id
}
