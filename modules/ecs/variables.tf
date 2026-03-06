variable "name" {
    description = "Name of the project"
    type        = string
}

variable "aws_region" {
    description = "AWS Region"
    type        = string
}

variable "vpc_id" {
    description = "Workload VPC ID"
    type        = string
}

variable "app_subnet_id" {
    description = "App subnet ID for ECS task"
    type        = string
}

variable "alb_security_group_id" {
    description = "Security group ID of Web ALB to allow inbound traffic"
    type        = string
}

variable "alb_target_group_arn" {
    description = "ARN of ALB target group the ECS service registers with"
    type        = string
}

variable "container_image" {
    description = "Docker image URI"
    type        = string
}

variable "container_port" {
    description = "Port the ECS container listens on"
    type        = number
}

variable "task_cpu" {
    description = "ECS task CPU"
    type        = number
}

variable "task_memory" {
    description = "ECS task memory"
    type        = number
}

variable "desired_count" {
    description = "Number of service to run by default"
    type        = number
}

variable "tags" {
    description = "Common resource tags"
    type        = map(string)
}