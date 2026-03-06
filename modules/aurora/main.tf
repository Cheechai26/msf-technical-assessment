# Security group
resource "aws_security_group" "this" {
    name        = "${var.name}-aurora-sg"
    description = "Only allow PostgreSQL port 5432 from ECS tasks"
    vpc_id      = var.vpc_id

    ingress {
        from_port       = var.db_port
        to_port         = var.db_port
        protocol        = "tcp"
        security_groups = [var.ecs_security_group_id]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = merge(var.tags, { Name = "${var.name}-aurora-sg"})
}

# Subnet Group
resource "aws_db_subnet_group" "this" {
    name       = "${var.name}-aurora-subnet-group"
    subnet_ids = var.data_subnet_ids
    tags       = merge(var.tags, { Name = "${var.name}-aurora-subnet-group"})
}

# Aurora Cluster
resource "aws_rds_cluster" "this" {
    cluster_identifier      = "${var.name}-aurora-cluster"
    engine                  = var.engine
    engine_version          = var.engine_version
    engine_mode             = "provisioned"
    port                    = var.db_port
    database_name           = var.db_name
    master_username         = var.master_username
    master_password         = var.master_password
    db_subnet_group_name    = aws_db_subnet_group.this.name
    vpc_security_group_ids  = [aws_security_group.this.id]
    storage_encrypted       = true
    deletion_protection     = false
    skip_final_snapshot     = true
    backup_retention_period = 1

    serverlessv2_scaling_configuration {
        min_capacity = 0.5
        max_capacity = 2.0
    }

    tags = merge(var.tags, { Name = "${var.name}-aurora-cluster"})
}

resource "aws_rds_cluster_instance" "this" {
    identifier           = "${var.name}-aurora-instance"
    cluster_identifier   = aws_rds_cluster.this.id
    instance_class       = "db.serverless"
    engine               = aws_rds_cluster.this.engine
    engine_version       = aws_rds_cluster.this.engine_version
    db_subnet_group_name = aws_db_subnet_group.this.name

    tags = merge(var.tags, { Name = "${var.name}-aurora-instance"})
}
