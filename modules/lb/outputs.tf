output "internet_alb_dns" {
    description = "Public DNS of the internet facing ALB"
    value       = aws_lb.internet.dns_name
}

output "internet_alb_arn" {
    description = "ARN of the internet facing ALB"
    value       = aws_lb.internet.arn
}

output "workload_nlb_dns" {
    description = "DNS of the internal workload NLB"
    value       = aws_lb.workload_nlb.dns_name
}

output "workload_alb_arn" {
    description = "ARN of the internal workload ALB"
    value       = aws_lb.workload_alb.arn
}

output "workload_alb_tg_arn" {
    description = "ARN of the internal workload ALB target group"
    value       = aws_lb_target_group.workload_alb.arn
}

output "workload_alb_sg_id" {
    description = "Security group ID of internal workload ALB"
    value       = aws_security_group.workload_alb.id
}