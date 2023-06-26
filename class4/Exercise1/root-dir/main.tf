module "db" {

  count  = 2
  source = "../db-dir"
}

output "name" {
  value = module.db[*].db_arn

}

output "second_db_name" {
  value = module.db[1].instance_name

}





#module "web_servers" {
#  source = "../ec2-custom"

# count         = 3
#  instance_type = "t3.micro"
#  ami_id        = "ami-022e1a32d3f742bd8"

#  tag_name = "WebServer ${count.index + 1}"
#}

/* module "webser_sg" {
  source = "../htttp-sg"

}

module "web_servers" {
  source             = "../ec2-custom"
  instance_type      = "t3.micro"
  ami_id             = "ami-022e1a32d3f742bd8"
  tag_name           = "WebServer"
  other_module_sg_id = module.webser_sg.sg_id

} */


/* module "web_servers_custom_name" {
  source = "../ec2-custom"

  count         = length(var.ec2_tags)
  instance_type = "t3.micro"
  ami_id        = "ami-022e1a32d3f742bd8"

  tag_name = var.ec2_tags[count.index]
} */


/* variable "ec2_tags" {
  type    = list(any)
  default = ["apha", "beta", "octa", "hexa"]

} */

#output "public_ips" {
#value = module.web_servers[*].public_ip

#}
