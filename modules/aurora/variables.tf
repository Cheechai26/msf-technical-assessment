variable "name" {
    description = "Name of the project"
    type        = string
}

variable "vpc_id" {
    description = "Workload VPC ID"
    type        = string
}

variable "data_subnet_ids" {
    description = "Data subnet IDs"
    type        = list(string)
}

variable "ecs_security_group_id" {
    description = "Security group ID of ECS tasks to allow inbound PostgreSQL traffic"
    type        = string
}

variable "engine" {
    description = "RDS Cluster engine"
    type        = string
    default     = "aurora-postgresql"
}

variable "engine_version" {
    description = "RDS Cluster engine version"
    type        = string
    default     = "15.8"
}

variable "db_name" {
    description = "Aurora database name"
    type        = string
}

variable "master_username" {
    description = "Aurora master username"
    type        = string
}

variable "master_password" {
    description = "Aurora master password"
    type        = string
    sensitive   = true
}

variable "db_port" {
    description = "Aurora database port"
    type        = number
    default     = 5432
}

variable "tags" {
    description = "Common resource tags"
    type        = map(string)
}