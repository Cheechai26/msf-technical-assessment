# Internet ALB
resource "aws_security_group" "alb" {
    name        = "${var.name}-internet-alb-sg"
    description = "Allow HTTP from anywhere for e2e test"
    vpc_id      = var.internet_vpc_id

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = merge(var.tags, { Name = "internet-alb-sg"})
}

resource "aws_lb" "internet" {
    name                = "${var.name}-internet-alb"
    internal            = false
    load_balancer_type  = "application"
    security_groups     = [aws_security_group.alb.id]
    subnets             = var.gateway_subnet_ids
    tags                = merge(var.tags, { Name = "internet-alb"})
}

resource "aws_lb_target_group" "internet_alb" {
    name        = "${var.name}-internet-alb-tg"
    port        = var.container_port
    protocol    = "HTTP"
    vpc_id      = var.internet_vpc_id
    target_type = "ip"

    health_check {
        path                = "/"
        protocol            = "HTTP"
        healthy_threshold   = 2
        unhealthy_threshold = 2
        interval            = 30
    }

    tags = merge(var.tags, { Name = "internet-alb-tg"})
}

resource "aws_lb_target_group_attachment" "internet_to_nlb" {
    count             = length(var.nlb_private_ips)
    target_group_arn  = aws_lb_target_group.internet_alb.arn
    target_id         = var.nlb_private_ips[count.index]
    port              = var.container_port
    availability_zone = "all"
}

resource "aws_lb_listener" "internet_http" {
    load_balancer_arn = aws_lb.internet.arn
    port              = 80
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.internet_alb.arn
    }
}

# Workload NLB
resource "aws_lb" "workload_nlb" {
    name                = "${var.name}-workload-nlb"
    internal            = true
    load_balancer_type  = "network"

    dynamic "subnet_mapping" {
        for_each = zipmap(var.web_subnet_ids, var.nlb_private_ips)
        content {
            subnet_id            = subnet_mapping.key
            private_ipv4_address = subnet_mapping.value
        }
    }

    tags                = merge(var.tags, { Name = "workload-nlb"})
}

resource "aws_lb_target_group" "nlb" {
    name        = "${var.name}-workload-nlb-tg"
    port        = var.container_port
    protocol    = "TCP"
    vpc_id      = var.workload_vpc_id
    target_type = "alb"

    health_check {
        path                = "/"
        protocol            = "HTTP"
        healthy_threshold   = 2
        unhealthy_threshold = 2
        interval            = 30
    }

    tags = merge(var.tags, { Name = "workload-nlb-tg"})
}

resource "aws_lb_listener" "nlb" {
    load_balancer_arn = aws_lb.workload_nlb.arn
    port              = var.container_port
    protocol          = "TCP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.nlb.arn
    }
}

resource "aws_lb_target_group_attachment" "nlb_to_alb" {
    target_group_arn = aws_lb_target_group.nlb.arn
    target_id        = aws_lb.workload_alb.arn
    port             = var.container_port

    depends_on = [aws_lb_listener.workload_alb]
}

# Workload ALB
resource "aws_security_group" "workload_alb" {
    name        = "${var.name}-workload-alb-sg"
    description = "Allow traffic from inside Workload VPC"
    vpc_id      = var.workload_vpc_id

    ingress {
        from_port   = var.container_port
        to_port     = var.container_port
        protocol    = "tcp"
        cidr_blocks = [var.workload_vpc_cidr]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = merge(var.tags, { Name = "workload-alb-sg"})
}

resource "aws_lb" "workload_alb" {
    name                = "${var.name}-workload-alb"
    internal            = true
    load_balancer_type  = "application"
    security_groups     = [aws_security_group.workload_alb.id]
    subnets             = var.web_subnet_ids
    tags                = merge(var.tags, { Name = "workload-alb"})
}

resource "aws_lb_target_group" "workload_alb" {
    name        = "${var.name}-workload-alb-tg"
    port        = var.container_port
    protocol    = "HTTP"
    vpc_id      = var.workload_vpc_id
    target_type = "ip"

    health_check {
        path                = "/"
        protocol            = "HTTP"
        healthy_threshold   = 2
        unhealthy_threshold = 2
        interval            = 30
    }

    tags = merge(var.tags, { Name = "workload-alb-tg"})
}

resource "aws_lb_listener" "workload_alb" {
    load_balancer_arn = aws_lb.workload_alb.arn
    port              = var.container_port
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.workload_alb.arn
    }
}
