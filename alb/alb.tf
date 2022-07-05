variable "vpc_id" {
  type = string
}
variable "Allow_ELB_Web_Traffic_id" {
  type = string
}

variable "Allow_ELB_App_Traffic_id" {
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
resource "aws_lb" "WEB_ALB" {
  name               = "WEB-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.Allow_ELB_Web_Traffic_id]
  subnets            = [var.aws_subnet_id2, var.aws_subnet_id1]         # aws_subnet.public.*.id

  enable_deletion_protection = false

#  access_logs {
#    bucket  = aws_s3_bucket.lb_logs.bucket
#    prefix  = "test-lb"
#    enabled = true
#  }

  tags = {
    Name = "WEB_Load_Balancer"
  }
}

# Create Target Group #

resource "aws_lb_target_group" "ELB_Target_Group1" {
  name     = "ELB-Target-Group1"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id


 # Alter the destination of the health check to be the login page.
  
  health_check {
    path = "/index.html"
    port = 80
    healthy_threshold   = 3
    unhealthy_threshold = 5
    timeout             = 10
#   target              = "HTTP:8000/"
    interval            = 30
    protocol            = "HTTP"

  }
}

# Create Listeners HTTP/HTTPS#

resource "aws_lb_listener" "WEB_ELB_Listener_HTTP" {
  load_balancer_arn = aws_lb.WEB_ALB.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ELB_Target_Group1.arn
  }
}

resource "aws_lb" "APP_ALB" {
  name               = "APP-ALB"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.Allow_ELB_App_Traffic_id]
  subnets            = [var.aws_subnet_pvid1, var.aws_subnet_pvid2]

  enable_deletion_protection = false

  tags = {
    Name = "APP_Load_Balancer"
  }
}

# Create Target Group #

resource "aws_lb_target_group" "ELB_Target_Group2" {
  name     = "ELB-Target-Group2"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  
    health_check {
    path = "/index.html"
    port = 80
    healthy_threshold   = 3
    unhealthy_threshold = 5
    timeout             = 10
    interval            = 30
    protocol            = "HTTP"
  }
}

# Create Listeners HTTP/HTTPS#

resource "aws_lb_listener" "APP_ELB_Listener_HTTP" {
  load_balancer_arn = aws_lb.APP_ALB.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ELB_Target_Group2.arn
  }
}

output "aws_lb_target_group_1" {
  value = aws_lb_target_group.ELB_Target_Group1.arn
}

output "aws_lb_target_group_2" {
  value = aws_lb_target_group.ELB_Target_Group2.arn
}