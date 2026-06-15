# ALB SECURITY GROUPS
resource "aws_security_group" "alb" {
  name   = "${var.project}-${var.environment}-alb-sg"
  vpc_id = var.vpc_id


  ingress {
    description = "Allow HTTP traffic from port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS traffic from port 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow TLS inbound traffic and all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-${var.environment}-alb-sg"
  }
}

# ECS SECURITY GROUP
resource "aws_security_group" "ecs" {
  name   = "${var.project}-${var.environment}-ecs-sg"
  vpc_id = var.vpc_id


  ingress {
    description     = "Allow HTTP traffic from ALB only"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    description = "Allow TLS inbound traffic and all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-${var.environment}-ecs-sg"
  }
}

# JENKINS SECURITY GROUP
resource "aws_security_group" "jenkins" {
  name   = "${var.project}-${var.environment}-jenkins-sg"
  vpc_id = var.vpc_id

  ingress {
    description = "Allow SSH from My IP only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.myIpAddress}/32"]
  }


  ingress {
    description = "Allow traffic to port 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow TLS inbound traffic and all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-${var.environment}-jenkins-sg"
  }
}
