output "vpc_id" {
    description = "ID of the Internet VPC"
    value       = aws_vpc.this.id
}

output "vpc_cidr" {
    description = "CIDR block of the Internet VPC"
    value       = aws_vpc.this.cidr_block
}

output "igw_id" {
    description = "ID of the Internet Gateway"
    value       = aws_internet_gateway.this.id
}

output "firewall_subnet_id" {
    description = "ID of the Firewall subnet"
    value       = aws_subnet.firewall.id
}

output "gateway_subnet_ids" {
    description = "IDs of the Gateway subnet"
    value       = aws_subnet.gateway[*].id
}

output "tgw_subnet_ids" {
    description = "IDs of the TGW subnets"
    value       = aws_subnet.tgw[*].id
}

output "nat_gateway_id" {
    description = "ID of the NAT Gateway"
    value       = aws_nat_gateway.this.id
}

output "igw_route_table_id" {
    description = "IGW ingress route table ID"
    value       = aws_route_table.igw_ingress.id
}

output "firewall_route_table_id" {
    description = "Route table ID of the Firewall subnet"
    value       = aws_route_table.firewall.id
}

output "gateway_route_table_id" {
    description = "Route table ID of the Gateway subnet"
    value       = aws_route_table.gateway.id
}

output "tgw_route_table_id" {
    description = "Route table ID of the TGW subnet"
    value       = aws_route_table.tgw.id
}
