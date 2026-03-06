variable "name" {
    description = "Name of the project"
    type        = string
}

variable "internet_vpc_id" {
    description = "Internet VPC ID"
    type        = string
}

variable "workload_vpc_id" {
    description = "Workload VPC ID"
    type        = string
}

variable "workload_vpc_cidr" {
    description = "CIDR block for Workload VPC"
    type        = string
}

variable "gateway_subnet_ids" {
    description = "Gateway Subnet IDs"
    type        = list(string)
}

variable "web_subnet_ids" {
    description = "Web Subnet IDs"
    type        = list(string)
}

variable "nlb_private_ips" {
    description = "Static private IPs for the workload NLB"
    type        = list(string)
}

variable "container_port" {
    description = "Port the service listens on"
    type        = number
}

variable "tags" {
    description = "Common resource tags"
    type        = map(string)
}