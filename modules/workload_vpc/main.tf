resource "aws_vpc" "this" {
    cidr_block           = var.cidr_block
    enable_dns_hostnames = true
    enable_dns_support   = true
    tags                 = merge(var.tags, { Name = "${var.name}-workload-vpc"})
}

# Subnets
resource "aws_subnet" "web" {
    count             = length(var.web_subnet_cidrs)
    vpc_id            = aws_vpc.this.id
    cidr_block        = var.web_subnet_cidrs[count.index]
    availability_zone = var.availability_zones[count.index]
    tags              = merge(var.tags, { Name = "${var.name}-workload-web-${var.availability_zones[count.index]}"})
}

resource "aws_subnet" "app" {
    vpc_id            = aws_vpc.this.id
    cidr_block        = var.app_subnet_cidr
    availability_zone = var.availability_zones[0]
    tags              = merge(var.tags, { Name = "${var.name}-workload-app"})
}

resource "aws_subnet" "data" {
    count             = length(var.data_subnet_cidrs)
    vpc_id            = aws_vpc.this.id
    cidr_block        = var.data_subnet_cidrs[count.index]
    availability_zone = var.availability_zones[count.index]
    tags              = merge(var.tags, { Name = "${var.name}-workload-data-${var.availability_zones[count.index]}"})
}

resource "aws_subnet" "tgw" {
    vpc_id            = aws_vpc.this.id
    cidr_block        = var.tgw_subnet_cidr
    availability_zone = var.availability_zones[0]
    tags              = merge(var.tags, { Name = "${var.name}-workload-tgw"})
}

# Route Tables
resource "aws_route_table" "web" {
    vpc_id = aws_vpc.this.id
    tags   = merge(var.tags, { Name = "${var.name}-workload-web-rt"})
}

resource "aws_route_table_association" "web" {
    count          = length(var.web_subnet_cidrs)
    subnet_id      = aws_subnet.web[count.index].id
    route_table_id = aws_route_table.web.id
}

resource "aws_route_table" "app" {
    vpc_id = aws_vpc.this.id
    tags   = merge(var.tags, { Name = "${var.name}-workload-app-rt"})
}

resource "aws_route_table_association" "app" {
    subnet_id      = aws_subnet.app.id
    route_table_id = aws_route_table.app.id
}

resource "aws_route_table" "data" {
    vpc_id = aws_vpc.this.id
    tags   = merge(var.tags, { Name = "${var.name}-workload-data-rt"})
}

resource "aws_route_table_association" "data" {
    count          = length(var.data_subnet_cidrs)
    subnet_id      = aws_subnet.data[count.index].id
    route_table_id = aws_route_table.data.id
}

resource "aws_route_table" "tgw" {
    vpc_id = aws_vpc.this.id
    tags   = merge(var.tags, { Name = "${var.name}-workload-tgw-rt"})
}

resource "aws_route_table_association" "tgw" {
    subnet_id      = aws_subnet.tgw.id
    route_table_id = aws_route_table.tgw.id
}
