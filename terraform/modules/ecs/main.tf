# ECS
resource "aws_ecs_cluster" "this" {
  name = "${var.project}-${var.environment}-ecs"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "${var.project}-${var.environment}-ecs"
  }
}

# FRONTEND TASK DEFINITION
resource "aws_ecs_task_definition" "frontend" {
  family                   = "${var.project}-${var.environment}-frontend"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = var.task_execution_role_arn

  container_definitions = jsonencode([
    {
      name      = "frontend"
      image     = var.frontend_ecr_url
      essential = true
      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "REACT_APP_API_URL"
          value = var.backend_url
        }
      ]
    }
  ])

  tags = {
    Name = "${var.project}-${var.environment}-frontend-td"
  }
}

# BACKEND TASK DEFINITION
resource "aws_ecs_task_definition" "backend" {
  family                   = "${var.project}-${var.environment}-backend"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = var.task_execution_role_arn

  container_definitions = jsonencode([
    {
      name      = "backend"
      image     = var.backend_ecr_url
      essential = true
      portMappings = [
        {
          containerPort = 8080
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "CORS_ORIGIN"
          value = var.frontend_url
        }
      ]
    }
  ])

  tags = {
    Name = "${var.project}-${var.environment}-backend-td"
  }
}

# FRONTEND SERVICE
resource "aws_ecs_service" "frontend" {
  name            = "${var.project}-${var.environment}-frontend-svc"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.frontend.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [var.private_subnet_a_id, var.private_subnet_b_id]
    security_groups  = [var.ecs_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "frontend"
    container_port   = 80
  }

  tags = {
    Name = "${var.project}-${var.environment}-frontend-svc"
  }
}

# BACKEND SERVICE
resource "aws_ecs_service" "backend" {
  name            = "${var.project}-${var.environment}-backend-svc"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.backend.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [var.private_subnet_a_id, var.private_subnet_b_id]
    security_groups  = [var.ecs_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.backend_target_group_arn
    container_name   = "backend"
    container_port   = 8080
  }

  tags = {
    Name = "${var.project}-${var.environment}-backend-svc"
  }
}
