# Create a security group for the Application Load Balancer, open port: 80.
resource "aws_security_group" "alb-security-group" {
  name        = "alb-security-group"
  description = "Application Load Balancer security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = local.http_port
    to_port     = local.http_port
    protocol    = local.tcp_protocol
    cidr_blocks = [var.allowed_cidr_blocks]
  }

  egress {
    from_port   = local.any_port
    to_port     = local.any_port
    protocol    = local.any_protocol
    cidr_blocks = local.all_ips
  }
}


# Create an Application Load Balancer
resource "aws_lb" "alb" {
  name            = "application-load-balancer"
  security_groups = [aws_security_group.alb-security-group.id]
  subnets         = var.alb_subnets


  tags = {
    Name = "application_load_balancer"
  }
}

# Create a target group and define stickiness
resource "aws_lb_target_group" "alb-target-group" {
  name     = "alb-target-group"
  port     = local.http_port
  protocol = local.http_protocol
  vpc_id   = var.vpc_id
  stickiness {
    # Enable stickiness.
    type = "lb_cookie"
    # Set cookie duration to one hour (3600s).
    cookie_duration = local.cookie_duration
  }
  # ALB will look for health_check file to determine instances health.
  health_check {
    path = local.health_check
    port = local.http_port
  }
}

resource "aws_lb_listener" "application-load-balancer-listener-http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = local.http_port
  protocol          = local.http_protocol

  default_action {
    target_group_arn = aws_lb_target_group.alb-target-group.arn
    type             = "forward"
  }
}