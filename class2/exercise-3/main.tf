
resource "aws_security_group" "allow_http_sg" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"
  # vpc_id      = aws_vpc.exercise_vpc.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Allow HTTP security group"
  }
}

resource "aws_instance" "webserver" {
  ami                    = "ami-022e1a32d3f742bd8"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.allow_http_sg.id]
  user_data              = <<-EOF
#!/bin/bash
yum install -y httpd
systemctl enable --now httpd
EOF

  tags = {
    Name = "WebServer"
  }
}

output "webserver_ip" {
  value = aws_instance.webserver.public_ip
}
