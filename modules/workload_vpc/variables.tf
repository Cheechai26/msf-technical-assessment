variable "name" {
    description = "Name of Workload VPC"
    type        = string
}

variable "cidr_block" {
    description = "CIDR block for Workload VPC"
    type        = string
}

variable "availability_zones" {
    description = "Availability zones to deploy subnets"
    type        = list(string)
}

variable "web_subnet_cidrs" {
    description = "CIDR blocks for web subnet"
    type        = list(string)
}

variable "app_subnet_cidr" {
    description = "CIDR block for app subnet"
    type        = string
}

variable "data_subnet_cidrs" {
    description = "CIDR blocks for data subnet"
    type        = list(string)
}

variable "tgw_subnet_cidr" {
    description = "CIDR block for tgw subnet"
    type        = string
}

variable "tags" {
    description = "Common resource tags"
    type        = map(string)
}
