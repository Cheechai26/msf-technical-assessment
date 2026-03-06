resource "aws_vpc" "this" {
    cidr_block           = var.cidr_block
    enable_dns_hostnames = true
    enable_dns_support   = true
    tags                 = merge(var.tags, { Name = "${var.name}-internet-vpc"})
}

resource "aws_internet_gateway" "this" {
    vpc_id = aws_vpc.this.id
    tags   = merge(var.tags, { Name = "${var.name}-internet-igw"})
}

# Subnets
resource "aws_subnet" "firewall" {
    vpc_id            = aws_vpc.this.id
    cidr_block        = var.firewall_subnet_cidr
    availability_zone = var.availability_zones[0]
    tags              = merge(var.tags, { Name = "${var.name}-internet-firewall"})
}

resource "aws_subnet" "gateway" {
    count             = length(var.gateway_subnet_cidrs)
    vpc_id            = aws_vpc.this.id
    cidr_block        = var.gateway_subnet_cidrs[count.index]
    availability_zone = var.availability_zones[count.index]
    tags              = merge(var.tags, { Name = "${var.name}-internet-gateway-${var.availability_zones[count.index]}"})
}

resource "aws_subnet" "tgw" {
    vpc_id            = aws_vpc.this.id
    cidr_block        = var.tgw_subnet_cidr
    availability_zone = var.availability_zones[0]
    tags              = merge(var.tags, { Name = "${var.name}-internet-tgw"})
}

# NAT Gateway
resource "aws_eip" "nat" {
    domain = "vpc"
    tags   = merge(var.tags, { Name = "${var.name}-nat-eip"})
}

resource "aws_nat_gateway" "this" {
    allocation_id = aws_eip.nat.id
    subnet_id     = aws_subnet.gateway[0].id
    tags          = merge(var.tags, { Name = "${var.name}-nat-gw"})

    depends_on = [aws_internet_gateway.this]
}

# Route Tables
resource "aws_route_table" "igw_ingress" {
    vpc_id = aws_vpc.this.id
    tags   = merge(var.tags, { Name = "${var.name}-internet-igw-ingress-rt"})
}

resource "aws_route_table_association" "igw_ingress" {
    gateway_id     = aws_internet_gateway.this.id
    route_table_id = aws_route_table.igw_ingress.id
}

resource "aws_route_table" "firewall" {
    vpc_id = aws_vpc.this.id
    tags   = merge(var.tags, { Name = "${var.name}-internet-firewall-rt"})
}

resource "aws_route_table_association" "firewall" {
    subnet_id      = aws_subnet.firewall.id
    route_table_id = aws_route_table.firewall.id
}

resource "aws_route_table" "gateway" {
    vpc_id = aws_vpc.this.id
    tags   = merge(var.tags, { Name = "${var.name}-internet-gateway-rt"})
}

resource "aws_route" "gateway_internet" {
    route_table_id         = aws_route_table.gateway.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "gateway" {
    count          = length(var.gateway_subnet_cidrs)
    subnet_id      = aws_subnet.gateway[count.index].id
    route_table_id = aws_route_table.gateway.id
}

resource "aws_route_table" "tgw" {
    vpc_id = aws_vpc.this.id
    tags   = merge(var.tags, { Name = "${var.name}-internet-tgw-rt"})
}

resource "aws_route_table_association" "tgw" {
    subnet_id      = aws_subnet.tgw.id
    route_table_id = aws_route_table.tgw.id
}
