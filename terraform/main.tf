# AWS Provider
provider "aws" {
  region = var.aws_region
}

#--------------------- Security Groups -------------------------
# Security group for your instance to allow specific IP inbound and all outbound
resource "aws_security_group" "reviews_server_sg" {
  name        = "${var.instance_name}_sg"
  description = "Allow all inbound traffic from specific IP"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # allow all traffic
    cidr_blocks = [var.my_ip_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # allow all traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "bitbucket_sg" {
  name        = "bitbucket_sg"
  description = "Allow all inbound traffic from specific IP"

  dynamic "ingress" {
    for_each = var.bitbucket_ips
    content {
      from_port   = 62222
      to_port     = 62222
      protocol    = "6" # allow all traffic
      cidr_blocks = [ingress.value]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "6" # allow all traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Security group to allow all traffic to the instance
resource "aws_security_group" "reviews_server_world_sg" {
  name        = "${var.world_security_group}_sg"
  description = "Allow all inbound traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # allow all traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security group for your Load Balancer to allow inbound and all outbound traffic
resource "aws_security_group" "reviews_server_lb_sg" {
  name        = "${var.alb_name}-lb-sg"
  description = "Allow inbound traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # allow all traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.alb_name}_lb_sg"
  }
}

#--------------------- EC2 Instance -------------------------
# EC2 instance
resource "aws_instance" "reviews_server" {
  ami                  = var.ami_id
  instance_type        = var.instance_type
  key_name             = var.key_name
  iam_instance_profile = var.iam_instance_profile

  lifecycle {
    create_before_destroy = true
  }

  ebs_block_device {
    device_name = "/dev/sda1"
    encrypted   = var.ebs_encrypted
    volume_size = var.ebs_volume_size
  }

  tags = {
    Name = var.instance_name
  }

  vpc_security_group_ids = [
    aws_security_group.reviews_server_sg.id,
    aws_security_group.reviews_server_world_sg.id,
    aws_security_group.bitbucket_sg.id
  ]
}

# Elastic IP associated with the instance
resource "aws_eip" "reviews_server_eip" {
  vpc        = true
  instance   = aws_instance.reviews_server.id
  depends_on = [aws_instance.reviews_server]
}

#--------------------- Load Balancer -------------------------
# Application Load Balancer
resource "aws_lb" "reviews_server_lb" {
  name               = "${var.alb_name}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.reviews_server_lb_sg.id]
  subnets            = var.subnets

  enable_deletion_protection = true

  tags = {
    Name = "${var.alb_name}-lb"
  }
}

# Listener for HTTP requests
resource "aws_lb_listener" "reviews_server_lb_listener" {
  load_balancer_arn = aws_lb.reviews_server_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# Listener for HTTPS requests
resource "aws_lb_listener" "reviews_server_lb_listener_https" {
  load_balancer_arn = aws_lb.reviews_server_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.reviews_server_lb_tg.arn
  }
}

# Target group for the load balancer
resource "aws_lb_target_group" "reviews_server_lb_tg" {
  name     = "${var.target_group_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

#--------------------- Route 53 Records -------------------------
# Route 53 record for root domain
resource "aws_route53_record" "root_domain" {
  zone_id = var.hosted_zone_id
  name    = var.hosted_zone_name
  type    = "A"

  alias {
    name                   = aws_lb.reviews_server_lb.dns_name
    zone_id                = aws_lb.reviews_server_lb.zone_id
    evaluate_target_health = false
  }
}

# Route 53 record for www subdomain
resource "aws_route53_record" "reviews_server_lb_dns" {
  zone_id = var.hosted_zone_id
  name    = "www" // change this to your preference
  type    = "A"

  alias {
    name                   = aws_lb.reviews_server_lb.dns_name
    zone_id                = aws_lb.reviews_server_lb.zone_id
    evaluate_target_health = false
  }
}

# Attachment of the instance to the target group of the load balancer
resource "aws_lb_target_group_attachment" "reviews_server_tg_attachment" {
  target_group_arn = aws_lb_target_group.reviews_server_lb_tg.arn
  target_id        = aws_instance.reviews_server.id
  port             = 80
}

#--------------------- Launch Template -------------------------
# resource "aws_launch_template" "reviews_server_lt" {
#   name_prefix   = "${var.instance_name}_lt"
#   description   = "Template for reviews server instances"
#   ebs_optimized = true
#   instance_type = var.instance_type
#   key_name      = var.key_name

#   block_device_mappings {
#     device_name = "/dev/sda1"

#     ebs {
#       encrypted = var.ebs_encrypted
#       volume_size = var.ebs_volume_size
#     }
#   }

#   iam_instance_profile {
#     name = var.iam_instance_profile
#   }

#   image_id = var.ami_id

#   vpc_security_group_ids = [
#     aws_security_group.reviews_server_sg.id,
#     aws_security_group.reviews_server_world_sg.id
#   ]

#   tag_specifications {
#     resource_type = "instance"

#     tags = {
#       Name = var.instance_name
#     }
#   }
# }

# #--------------------- Auto Scaling Group -------------------------
# resource "aws_autoscaling_group" "reviews_server_asg" {
#   desired_capacity = var.desired_capacity
#   max_size         = var.max_size
#   min_size         = var.min_size

#   launch_template {
#     id      = aws_launch_template.reviews_server_lt.id
#     version = "$Latest"
#   }

#   vpc_zone_identifier = var.subnets

#   tag {
#     key                 = "Name"
#     value               = "${var.instance_name}_asg"
#     propagate_at_launch = true
#   }

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# # Remove these resources as they are not required with an Auto Scaling Group
# resource "aws_instance" "reviews_server" {...}
# resource "aws_eip" "reviews_server_eip" {...}
# resource "aws_lb_target_group_attachment" "reviews_server_tg_attachment" {...}
