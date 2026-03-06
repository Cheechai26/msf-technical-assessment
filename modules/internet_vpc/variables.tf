variable "name" {
    description = "Name of Internet VPC"
    type        = string
}

variable "cidr_block" {
    description = "CIDR block for Internet VPC"
    type        = string
}

variable "availability_zones" {
    description = "Availability zones to deploy subnets"
    type = list(string)
}

variable "firewall_subnet_cidr" {
    description = "CIDR block for firewall subnet"
    type        = string
}

variable "gateway_subnet_cidrs" {
    description = "CIDR blocks for gateway subnet"
    type        = list(string)
}

variable "tgw_subnet_cidrs" {
    description = "CIDR blocks for tgw subnets"
    type        = list(string)
}

variable "tags" {
    description = "Common resource tags"
    type        = map(string)
}

