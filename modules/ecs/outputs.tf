output "ecs_cluster_id" {
    description = "ECS cluster ID"
    value       = aws_ecs_cluster.this.id
}

output "ecs_cluster_name" {
    description = "Name of the ECS cluster"
    value       = aws_ecs_cluster.this.name
}

output "ecs_cluster_arn" {
    description = "ECS cluster ARN"
    value       = aws_ecs_cluster.this.arn
}

output "ecs_service_name" {
    description = "Name of the ECS service"
    value       = aws_ecs_service.this.name
}

output "ecs_task_definition_arn" {
    description = "ECS Task Definition ARN"
    value       = aws_ecs_task_definition.this.arn
}

output "ecs_security_group_id" {
    description = "Security group ID attached to ECS tasks"
    value       = aws_security_group.this.id
}

output "ecs_log_group_name" {
    description = "Cloudwatch log group name for ECS task"
    value       = aws_cloudwatch_log_group.this.name
}