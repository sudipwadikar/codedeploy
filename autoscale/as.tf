variable "Allow_Web_Traffic_id" {
  type = string
}

variable "Allow_APP_Traffic_id" {
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

variable "aws_lb_target_group_1" {
  type = string
}

variable "aws_lb_target_group_2" {
  type = string
}

resource "aws_launch_configuration" "web_launch_config" {
  name_prefix                 = "WEB-Autoscaling"
  image_id                    = "ami-065efef2c739d613b" #Amazon Linux 2 AMI
  instance_type               = "t2.micro"
  key_name                    = "ubuntus1"
  associate_public_ip_address = true
  security_groups             = [var.Allow_Web_Traffic_id]

  user_data = <<-EOF
              #!/bin/bash
              sudo -i
              sudo yum install httpd
              sudo systemctl start httpd
              sudo systemctl enable httpd
              sudo systemctl status httpd
              sudo yum install amazon-linux-extras php
              sudo yum install php-curl php-mbstring php-intl php-opcache php-soap php-gd php-xml php-mysqli
              php –version
              sudo systemctl restart httpd
              EOF
  
lifecycle {
    create_before_destroy = true
  }
}

# Create Auto Scaling Group #

resource "aws_autoscaling_group" "autoscaling_group" {
  launch_configuration = "${aws_launch_configuration.web_launch_config.id}"
  min_size             = "2"
  max_size             = "3"
  target_group_arns    = [var.aws_lb_target_group_1]
  vpc_zone_identifier  = [var.aws_subnet_id1, var.aws_subnet_id2]

  tag {
    key                 = "Name"
    value               = "WEB-Server"
    propagate_at_launch = true
  }
}

####################################################
## Autosclaing for APP Tier
#####################################################

# Create Launch Configuration #

resource "aws_launch_configuration" "app_launch_config" {
  name_prefix                 = "APP-Autoscaling"
  image_id                    = "ami-065efef2c739d613b" #Amazon Linux 2 AMI
  instance_type               = "t2.micro"
  key_name                    = "ubuntus1"
  associate_public_ip_address = false
  security_groups             = [var.Allow_APP_Traffic_id]

  
  lifecycle {
    create_before_destroy = true
  }
}

# Create Auto Scaling Group #

resource "aws_autoscaling_group" "app_autoscaling_group" {
  launch_configuration = "${aws_launch_configuration.app_launch_config.id}"
  min_size             = "2"
  max_size             = "3"
  target_group_arns    = [var.aws_lb_target_group_2]
  vpc_zone_identifier  = [var.aws_subnet_pvid1, var.aws_subnet_pvid2]

  tag {
    key                 = "Name"
    value               = "APP-Server"
    propagate_at_launch = true
  }
}
