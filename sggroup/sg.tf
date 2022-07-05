variable "vpc_id" {
  type = string
}

variable "aws_subnet_id1" {
  type = string
}

variable "aws_subnet_id2" {
  type = string
}

resource "aws_security_group" "Allow_Web_Traffic" {
  name        = "allow_web_ssh_traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow_Web_SSH_Access"
  }
}

resource "aws_security_group" "sg-bastion" {
  name   = "bastion-security-group"
  vpc_id = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0 
    to_port     = 0 
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bastion-host" {
  ami                         = "ami-065efef2c739d613b"
  key_name                    = "ubuntus1"
  instance_type               = "t2.micro"
  subnet_id = var.aws_subnet_id1
  vpc_security_group_ids            = [aws_security_group.sg-bastion.id]
  associate_public_ip_address = true
}

resource "aws_security_group" "Allow_APP_Traffic" {
  name        = "allow_APP_web_ssh_traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }



  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow_APP_Web_SSH_Access"
  }
}

resource "aws_security_group" "Allow_ELB_Web_Traffic" {
  name        = "allow_ELB_web_traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
#   ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
#   ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Allow_ELB_WEB_Access"
  }
}

resource "aws_security_group" "Allow_ELB_App_Traffic" {
  name        = "allow_ELB_App_traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow_ELB_WEB_Access"
  }
}

output "Allow_ELB_Web_Traffic" {
  value = aws_security_group.Allow_ELB_Web_Traffic.id
}

output "Allow_ELB_App_Traffic" {
  value = aws_security_group.Allow_ELB_App_Traffic.id
}

output "Allow_Web_Traffic" {
  value = aws_security_group.Allow_Web_Traffic.id
}

output "Allow_APP_Traffic" {
  value = aws_security_group.Allow_APP_Traffic.id
}