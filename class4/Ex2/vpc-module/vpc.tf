
resource "aws_vpc" "exercise_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "tf-vpc-1"
  }
}

resource "aws_subnet" "subnet_a" {
  vpc_id     = aws_vpc.exercise_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "tf-subnet-a"
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id     = aws_vpc.exercise_vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "tf-subnet-b"
  }
}

output "vpc_id" {
  value = aws_vpc.exercise_vpc.id

}

output "subnet_one" {
  value = aws_subnet.subnet_a.id

}
