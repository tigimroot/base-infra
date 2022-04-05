output "loadbalancer_id" {
  description = "loadb_id"
  value = aws_lb.alb.id
}
output "alb_tg_arn" {
  description = "tg_arn"
  value = aws_lb_target_group.alb_tg.arn
}

output "alb_sg"{
  description = "security group id"
  value = aws_security_group.octarine_lb_sg.id
}
