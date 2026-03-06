variable "name" {
    description = "Name of the project"
    type        = string
}

variable "internet_vpc_id" {
    description = "ID of the internet VPC to attach to TGW"
    type        = string
}

variable "internet_tgw_subnet_id" {
    description = "Subnet ID in the Internet VPC"
    type        = string
}

variable "internet_gateway_route_table_id" {
    description = "Route table ID in the Internet VPC gateway subnet require to route to Workload VPC thru TGW"
    type        = string
}

variable "workload_vpc_id" {
    description = "ID of the workload VPC to attach to TGW"
    type        = string
}

variable "workload_tgw_subnet_id" {
    description = "Subnet ID in the Workload VPC"
    type        = string
}

variable "workload_app_route_table_id" {
    description = "Route table ID in the Workload VPC app subnet that require default egress thru TGW"
    type        = string
}

variable "workload_vpc_cidr" {
    description = "CIDR block of the Workload VPC to be routed from Internet VPC via TGW"
    type        = string
}

variable "tags" {
    description = "Common resource tags"
    type        = map(string)
}