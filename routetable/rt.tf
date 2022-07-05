variable "vpc_id" {
  type = string
}

variable "igw_id" {
  type = string
}

variable "aws_subnet_id1" {
  type = string
}

variable "aws_subnet_id2" {
  type = string
}

variable "aws_subnet_pvid1" {
  type = string
}

variable "aws_subnet_pvid2" {
  type = string
}

variable "Nat_Gateway1_id" {
  type = string
}

resource "aws_route_table" "Route_Table" {

  vpc_id = var.vpc_id

  tags = {
      Name = "Public-RT"
  }
}

resource "aws_route" "public" {
  
  route_table_id = aws_route_table.Route_Table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = var.igw_id
}

resource "aws_route_table_association" "public1" {
  route_table_id = aws_route_table.Route_Table.id
  subnet_id = var.aws_subnet_id1
}

resource "aws_route_table_association" "public2" {
  subnet_id = var.aws_subnet_id2
  route_table_id = aws_route_table.Route_Table.id
}

resource "aws_route_table" "private" {
  vpc_id = var.vpc_id
  
  tags = {
      Name = "Private-RT"
  }
}

resource "aws_route" "private1" {
  
  route_table_id = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = var.Nat_Gateway1_id
}

## Route Table Association for Private subnet

resource "aws_route_table_association" "private1" {
  route_table_id = aws_route_table.private.id
  subnet_id = var.aws_subnet_pvid1
}

resource "aws_route_table_association" "private2" {
  route_table_id = aws_route_table.private.id
  subnet_id = var.aws_subnet_pvid2
}