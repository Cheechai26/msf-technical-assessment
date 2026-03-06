# IAM
resource "aws_iam_role" "ecs_execution" {
    name = "${var.name}-ecs-execution-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Action     = "sts:AssumeRole"
            Effect     = "Allow"
            Principal  = {
                Service = "ecs-tasks.amazonaws.com"
            }
        }]
    })

    tags = merge(var.tags, { Name = "${var.name}-ecs-execution-role"})
}

resource "aws_iam_role_policy_attachment" "ecs_execution" {
    role       = aws_iam_role.ecs_execution.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Cloudwatch
resource "aws_cloudwatch_log_group" "this" {
    name              = "/ecs/${var.name}"
    retention_in_days = 7
    tags              = merge(var.tags, { Name = "${var.name}-cloudwatch"})
}

# Security Group
resource "aws_security_group" "this" {
    name            = "${var.name}-ecs-sg"
    description     = "Allow inbound from workload ALB only"
    vpc_id          = var.vpc_id

    ingress {
        from_port       = var.container_port
        to_port         = var.container_port
        protocol        = "tcp"
        security_groups = [ var.alb_security_group_id]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = merge(var.tags, { Name = "${var.name}-ecs-sg"})
}
 
# ECS Cluster
resource "aws_ecs_cluster" "this" {
    name = "${var.name}-cluster"

    setting {
        name  = "containerInsights"
        value = "enabled"
    }

    tags = merge(var.tags, { Name = "${var.name}-cluster"})
}

# Task Definition
resource "aws_ecs_task_definition" "this" {
    family                   = "${var.name}"
    requires_compatibilities = ["FARGATE"]
    network_mode             = "awsvpc"
    cpu                      = var.task_cpu
    memory                   = var.task_memory
    execution_role_arn       = aws_iam_role.ecs_execution.arn
    

    container_definitions = jsonencode([{
        name       = "${var.name}"
        image      = var.container_image
        essential  = true

        portMappings = [
            {
                containerPort = var.container_port
                protocol      = "tcp"
            }
        ]

        logConfiguration = {
            logDriver = "awslogs"
            options = {
                "awslogs-group"         = aws_cloudwatch_log_group.this.name
                "awslogs-region"        = var.aws_region
                "awslogs-stream-prefix" = var.name
            }
        }

    }])

    tags = merge(var.tags, { Name = "${var.name}-ecs-task"})
}

resource "aws_ecs_service" "this" {
    name            = "${var.name}-service"
    cluster         = aws_ecs_cluster.this.id
    task_definition = aws_ecs_task_definition.this.arn
    desired_count   = var.desired_count
    launch_type     = "FARGATE"

    network_configuration {
      subnets          = [var.app_subnet_id]
      security_groups  = [aws_security_group.this.id]
      assign_public_ip = false
    }

    load_balancer {
        target_group_arn = var.alb_target_group_arn
        container_name   = var.name
        container_port   = var.container_port
    }

    deployment_circuit_breaker {
      enable   = true
      rollback = true
    }

    tags = merge(var.tags, { Name = "${var.name}-ecs-service"})

    depends_on = [ aws_iam_role_policy_attachment.ecs_execution ]
}

