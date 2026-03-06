# general
variable "aws_region" {
    description = "AWS region to deploy into"
    type        = string
    default     = "ap-southeast-1"
}

variable "project_name" {
    description = "Project name used for resource naming and tagging"
    type        = string
    default     = "msf-assessment"
}

variable "environment" {
    description = "Deployment environment"
    type        = string
}

variable "availability_zones" {
    description = "Availability zones to deploy subnets into"
    type        = list(string)
}

# Internet VPC
variable "internet_vpc_cidr" {
    description = "CIDR block for Internet VPC"
    type        = string
}

variable "firewall_subnet_cidr" {
    description = "CIDR block for firewall subnet"
    type        = string
}

variable "gateway_subnet_cidrs" {
    description = "CIDR blocks for gateway subnets"
    type        = list(string)
}

variable "tgw_subnet_cidrs_internet" {
    description = "CIDR blocks for TGW subnets in Internet VPC"
    type        = list(string)
}

# Workload VPC
variable "workload_vpc_cidr" {
    description = "CIDR block for Workload VPC"
    type        = string
}

variable "web_subnet_cidrs" {
    description = "CIDR blocks for web subnets"
    type        = list(string)
}

variable "app_subnet_cidr" {
    description = "CIDR block for app subnet"
    type        = string
}

variable "data_subnet_cidrs" {
    description = "CIDR blocks for data subnets"
    type        = list(string)
}

variable "tgw_subnet_cidr_workload" {
    description = "CIDR block for TGW subnet in Workload VPC"
    type        = string
}

variable "nlb_private_ips" {
    description = "Static private IPs for the workload NLB"
    type        = list(string)
}

# ECS
variable "container_image" {
    description = "Docker image URI for the ECS task"
    type        = string
    default     = "k8s.gcr.io/e2e-test-images/echoserver:2.5"
}

variable "container_port" {
    description = "Port the container listens on"
    type        = number
    default     = 8080
}

variable "task_cpu" {
    description = "ECS task CPU units"
    type        = number
    default     = 256
}

variable "task_memory" {
    description = "ECS task memory in MiB"
    type        = number
    default     = 512
}

# Aurora
variable "desired_count" {
    description = "Number of ECS tasks to run"
    type        = number
    default     = 1
}

variable "db_port" {
    description = "Aurora database port"
    type        = number
    default     = 5432
}

variable "db_name" {
    description = "Aurora database name"
    type        = string
    default     = "appdb"
}

variable "master_username" {
    description = "Aurora master username"
    type        = string
    default     = "dbadmin"
}

variable "master_password" {
    description = "Aurora master password"
    type        = string
    sensitive   = true
}

variable "tags" {
    description = "Common resource tags"
    type        = map(string)
    default     = {}
}
