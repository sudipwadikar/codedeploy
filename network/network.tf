variable "vpc_id" {
  type = string
}

variable "igw_id" {
  type = string
}

resource "aws_subnet" "Public_Subnet_Web_1" {
    vpc_id = var.vpc_id
    cidr_block = "10.0.0.16/28"
    availability_zone = "us-east-1a"
    tags = {
      "Name" = "Public_Subnet_Web_1"
    }
}

resource "aws_subnet" "Public_Subnet_Web_2" {
    vpc_id = var.vpc_id
    cidr_block = "10.0.0.32/28"
    availability_zone = "us-east-1b"
    tags ={
        Name = "Public_Subnet_Web_2"
    }
}

#Create EIP
resource "aws_eip" "nat_gateway1" {
  vpc = true
}

#Create Nat Gateway

resource "aws_nat_gateway" "Nat_Gateway1" {
  allocation_id     = aws_eip.nat_gateway1.id
  subnet_id         = aws_subnet.Public_Subnet_Web_1.id  ##changed

  tags = {
    Name = "NAT_Gateway1"
  }

}

resource "aws_subnet" "Private_Subnet_App1" {
  vpc_id     = var.vpc_id
  cidr_block = "10.0.0.48/28"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "Private_Subnet_App1"
  }
}

resource "aws_subnet" "Private_Subnet_App2" {
  vpc_id     = var.vpc_id
  cidr_block = "10.0.0.64/28"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "Private_Subnet_App2"
  }
}

resource "aws_subnet" "Private_Subnet_DB2" {
  vpc_id     = var.vpc_id
  cidr_block = "10.0.0.80/28"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "Private_Subnet_DB2"
  }
}

resource "aws_subnet" "Private_Subnet_DB1" {
  vpc_id     = var.vpc_id
  cidr_block = "10.0.0.96/28"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "Private_Subnet_DB1"
  }
}

resource "aws_db_subnet_group" "db-subnet" {
  name = "db subnet group"
  subnet_ids = ["${aws_subnet.Private_Subnet_DB1.id}", "${aws_subnet.Private_Subnet_DB2.id}"]
}


output "nat_gateway_ip1" {
  value = aws_eip.nat_gateway1.public_ip
}

output "aws_subnet_id1" {
  value = aws_subnet.Public_Subnet_Web_1.id
}

output "aws_subnet_id2" {
  value = aws_subnet.Public_Subnet_Web_2.id
}

output "aws_subnet_pvid1" {
  value = aws_subnet.Private_Subnet_App1.id
}

output "aws_subnet_pvid2" {
  value = aws_subnet.Private_Subnet_App2.id
}

output "Nat_Gateway1_id" {
  value = aws_nat_gateway.Nat_Gateway1.id
}

output "aws_db_subnet_group_id" {
  value = aws_db_subnet_group.db-subnet.id
}