output "aurora_endpoint" {
    description = "Aurora endpoint"
    value       = aws_rds_cluster.this.endpoint
}

output "aurora_cluster_id" {
    description = "Aurora cluster ID"
    value       = aws_rds_cluster.this.id
}

output "db_name" {
    description = "Aurora database name"
    value       = aws_rds_cluster.this.database_name
}

output "port" {
    description = "Aurora Port"
    value       = aws_rds_cluster.this.port
}

output "security_group_id" {
    description = "Security group ID attached to Aurora"
    value       = aws_security_group.this.id
}

