output "alb_id" {
  value = aws_lb.alb.id
}

output "alb-security-group_id" {
  value = aws_security_group.alb-security-group.id
}
output "alb-target-group_arn" {
  value = aws_lb_target_group.alb-target-group.arn
}
