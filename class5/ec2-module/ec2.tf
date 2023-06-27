resource "aws_instance" "webserver" {
  ami           = "ami-022e1a32d3f742bd8"
  instance_type = var.webtype
  #vpc_security_group_ids = [aws_security_group.allow_http_sg.id]
  user_data = <<-EOF
#!/bin/bash
yum install -y httpd
systemctl enable --now httpd
EOF

  tags = {
    Name = "WebServer"
  }
}



