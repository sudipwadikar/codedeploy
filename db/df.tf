variable "vpc_id" {
  type = string
}

variable "aws_db_subnet_group_id" {
  type = string
}

resource "aws_security_group" "Allow_DB_Traffic" {
  name        = "allow_DB_ssh_traffic"
  description = "Allow inbound 3306"
  vpc_id      = var.vpc_id

  ingress {
    description      = "MYSQL"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["10.0.0.80/28", "10.0.0.96/28"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow_RDS_Access"
  }
}

resource "aws_db_instance" "RDS-Test" {
  allocated_storage    =  20
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  db_name              = "mydb"
  username             = "admin"
  password             = "password123"
  skip_final_snapshot  = true
  vpc_security_group_ids   =  [aws_security_group.Allow_DB_Traffic.id]
  parameter_group_name = "default.mysql5.7"
  db_subnet_group_name = var.aws_db_subnet_group_id
  multi_az             = false
}