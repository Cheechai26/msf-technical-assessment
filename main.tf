terraform {
    required_version = ">=1.5.0"
    required_providers {
       aws = {
        source = "hashicorp/aws"
        version = "~>5.0"
       }
    }
}

provider "aws" {
    region = var.aws_region

    default_tags {
        tags = {
            Project     = var.project_name
            Environment = var.environment
            ManageBy    = "terraform"
        }
    }
}

module "internet_vpc" {
    source = "./modules/internet_vpc"

    name                  = var.project_name
    cidr_block            = var.internet_vpc_cidr
    availability_zones    = var.availability_zones
    firewall_subnet_cidr  = var.firewall_subnet_cidr
    gateway_subnet_cidrs  = var.gateway_subnet_cidrs
    tgw_subnet_cidr       = var.tgw_subnet_cidr_internet
    tags                  = var.tags
}

module "workload_vpc" {
    source = "./modules/workload_vpc"

    name                  = var.project_name
    cidr_block            = var.workload_vpc_cidr
    availability_zones    = var.availability_zones
    web_subnet_cidrs      = var.web_subnet_cidrs
    app_subnet_cidr       = var.app_subnet_cidr
    data_subnet_cidrs     = var.data_subnet_cidrs
    tgw_subnet_cidr       = var.tgw_subnet_cidr_workload
    tags                  = var.tags
}

module "tgw" {
    source = "./modules/tgw"

    name                            = var.project_name
    internet_vpc_id                 = module.internet_vpc.vpc_id
    internet_tgw_subnet_id          = module.internet_vpc.tgw_subnet_id
    internet_gateway_route_table_id = module.internet_vpc.gateway_route_table_id
    workload_vpc_id                 = module.workload_vpc.vpc_id
    workload_tgw_subnet_id          = module.workload_vpc.tgw_subnet_id
    workload_app_route_table_id     = module.workload_vpc.app_route_table_id
    workload_vpc_cidr               = module.workload_vpc.vpc_cidr
    tags                            = var.tags
}

module "lb" {
    source = "./modules/lb"

    name               = var.project_name
    internet_vpc_id    = module.internet_vpc.vpc_id
    workload_vpc_id    = module.workload_vpc.vpc_id
    workload_vpc_cidr  = module.workload_vpc.vpc_cidr
    gateway_subnet_ids = module.internet_vpc.gateway_subnet_ids
    web_subnet_ids     = module.workload_vpc.web_subnet_ids
    nlb_private_ips    = var.nlb_private_ips
    container_port     = var.container_port
    tags               = var.tags
}

module "ecs" {
    source = "./modules/ecs"

    name                  = var.project_name
    aws_region            = var.aws_region
    vpc_id                = module.workload_vpc.vpc_id
    app_subnet_id         = module.workload_vpc.app_subnet_id
    alb_security_group_id = module.lb.workload_alb_sg_id
    alb_target_group_arn  = module.lb.workload_alb_tg_arn
    container_image       = var.container_image
    container_port        = var.container_port
    task_cpu              = var.task_cpu
    task_memory           = var.task_memory
    desired_count         = var.desired_count
    tags                  = var.tags
}

module "aurora" {
    source = "./modules/aurora"

    name                   = var.project_name
    vpc_id                 = module.workload_vpc.vpc_id
    data_subnet_ids        = module.workload_vpc.data_subnet_ids
    ecs_security_group_id  = module.ecs.ecs_security_group_id
    db_port                = var.db_port
    db_name                = var.db_name
    master_username        = var.master_username
    master_password        = var.master_password
    tags                   = var.tags
}
