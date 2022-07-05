resource "aws_vpc" "DemoVPC" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "DemoVPC"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.DemoVPC.id

  tags = {
    "Name" = "IGW"
  }
}

output "vpc_id" {
  value = aws_vpc.DemoVPC.id
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}