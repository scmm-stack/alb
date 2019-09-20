variable "allowed_cidr_blocks" {
  description = "Allowed IP range in (CIDR format)"
  type        = string
}
variable "vpc_id" {
  description = "Custom VPC ID"
  type        = string
}
variable "alb_subnets" {
  description = "Availability Zones for the Application Load Balancer"
  type        = list(string)
}
locals {
  http_port       = 80
  any_port        = 0
  cookie_duration = 3600
  any_protocol    = "-1"
  tcp_protocol    = "tcp"
  http_protocol   = "HTTP"
  all_ips         = ["0.0.0.0/0"]
  health_check    = "/health_check"
}