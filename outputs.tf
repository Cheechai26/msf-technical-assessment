output "internet_alb_dns" {
    description = "DNS of internet facing ALB"
    value       = module.lb.internet_alb_dns
}

output "internet_vpc_id" {
    description = "Internet VPC ID"
    value       = module.internet_vpc.vpc_id
}

output "workload_vpc_id" {
    description = "Workload VPC ID"
    value       = module.workload_vpc.vpc_id
}

output "transit_gateway_id" {
    description = "Transit Gateway ID"
    value       = module.tgw.transit_gateway_id
}

output "ecs_cluster_name" {
    description = "ECS cluster name"
    value       = module.ecs.ecs_cluster_name
}

output "ecs_service_name" {
    description = "ECS service name"
    value       = module.ecs.ecs_service_name
}

output "ecs_log_group" {
    description = "Cloudwatch log group for ECS task output"
    value       = module.ecs.ecs_log_group_name
}

output "aurora_endpoint" {
    description = "Aurora writer endpoint"
    value       = module.aurora.aurora_endpoint
}

output "aurora_cluster_id" {
    description = "Aurora cluster identifier"
    value       = module.aurora.aurora_cluster_id
}