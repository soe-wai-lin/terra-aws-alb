output "alb_dns_name" {
  value = aws_lb.lb.dns_name
  description = "The domain name of the load balancer"
}

output "asg_name" {
  value = aws_autoscaling_group.asg.name
  description = "The name of the Auto Scaling Group"
}

output "alb_security_group_id" {
  value = aws_security_group.alb.id
  description = "The ID of the Security Group attached to the load balancer"
}

output "region" {
  value = var.aws_region
}