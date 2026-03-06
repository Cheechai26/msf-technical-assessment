# Transit Gateway
resource "aws_ec2_transit_gateway" "this" {
    description                     = "Transit Gateway to connect Internet and Workload VPC" 
    default_route_table_association = "disable" 
    default_route_table_propagation = "disable"
    tags                            = merge(var.tags, { Name = "${var.name}-tgw" })
}

# TWG VPC Attachments
resource "aws_ec2_transit_gateway_vpc_attachment" "internet" {
    transit_gateway_id                              = aws_ec2_transit_gateway.this.id
    vpc_id                                          = var.internet_vpc_id 
    subnet_ids                                      = [var.internet_tgw_subnet_id]
    transit_gateway_default_route_table_association = false
    transit_gateway_default_route_table_propagation = false
    tags                                            = merge(var.tags, { Name = "${var.name}-tgw-attach-internet" })
}

resource "aws_ec2_transit_gateway_vpc_attachment" "workload" {
    transit_gateway_id                              = aws_ec2_transit_gateway.this.id
    vpc_id                                          = var.workload_vpc_id 
    subnet_ids                                      = [var.workload_tgw_subnet_id]
    transit_gateway_default_route_table_association = false
    transit_gateway_default_route_table_propagation = false
    tags                                            = merge(var.tags, { Name = "${var.name}-tgw-attach-workload" })
}

# TWG Route Tables
resource "aws_ec2_transit_gateway_route_table" "internet" {
    transit_gateway_id = aws_ec2_transit_gateway.this.id
    tags               = merge(var.tags, { Name = "${var.name}-tgw-rt-internet"})
}

resource "aws_ec2_transit_gateway_route_table" "workload" {
    transit_gateway_id = aws_ec2_transit_gateway.this.id
    tags               = merge(var.tags, { Name = "${var.name}-tgw-rt-workload"})
}

resource "aws_ec2_transit_gateway_route_table_association" "internet" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.internet.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.internet.id
}

resource "aws_ec2_transit_gateway_route_table_association" "workload" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.workload.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.workload.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "internet_to_workload" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.internet.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.workload.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "workload_to_internet" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.workload.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.internet.id
}

# VPC routes
resource "aws_route" "internet_to_workload" {
    route_table_id         = var.internet_gateway_route_table_id
    destination_cidr_block = var.workload_vpc_cidr
    transit_gateway_id     = aws_ec2_transit_gateway.this.id

    depends_on             = [ aws_ec2_transit_gateway_vpc_attachment.internet ]
}

resource "aws_route" "workload_to_egress" {
    route_table_id         = var.workload_app_route_table_id
    destination_cidr_block = "0.0.0.0/0"
    transit_gateway_id     = aws_ec2_transit_gateway.this.id 

    depends_on             = [ aws_ec2_transit_gateway_vpc_attachment.workload ] 
}
