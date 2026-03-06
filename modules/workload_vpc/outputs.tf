output "vpc_id" {
    description = "ID of the Workload VPC"
    value       = aws_vpc.this.id
}

output "vpc_cidr" {
    description = "CIDR block of the Workload VPC"
    value       = aws_vpc.this.cidr_block
}

output "web_subnet_ids" {
    description = "IDs of the Web subnet"
    value       = aws_subnet.web[*].id
}

output "app_subnet_id" {
    description = "ID of the App subnet"
    value       = aws_subnet.app.id
}

output "data_subnet_ids" {
    description = "IDs of the Data subnet"
    value       = aws_subnet.data[*].id
}

output "tgw_subnet_id" {
    description = "ID of the TGW subnet"
    value       = aws_subnet.tgw.id
}

output "web_route_table_id" {
    description = "Route table ID of the Web subnet"
    value       = aws_route_table.web.id
}

output "app_route_table_id" {
    description = "Route table ID of the App subnet"
    value       = aws_route_table.app.id
}

output "data_route_table_id" {
    description = "Route table ID of the Data subnet"
    value       = aws_route_table.data.id
}

output "tgw_route_table_id" {
    description = "Route table ID of the TGW subnet"
    value       = aws_route_table.tgw.id
}