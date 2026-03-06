output "transit_gateway_id" {
    description = "Transit Gateway ID"
    value       = aws_ec2_transit_gateway.this.id
}

output "internet_attachment_id" {
    description = "TGW attachment ID for the Internet VPC"
    value       = aws_ec2_transit_gateway_vpc_attachment.internet.id
}

output "workload_attachment_id" {
    description = "TGW attachment ID for the Workload VPC"
    value       = aws_ec2_transit_gateway_vpc_attachment.workload.id
}