# ECR for Frontend
resource "aws_ecr_repository" "frontend" {
  name                 = "${var.project}-${var.environment}-frontend-ecr"
  image_tag_mutability = "MUTABLE"
  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${var.project}-${var.environment}-frontend-ecr"
  }
}

# ECR for Backend
resource "aws_ecr_repository" "backend" {
  name                 = "${var.project}-${var.environment}-backend-ecr"
  image_tag_mutability = "MUTABLE"
  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${var.project}-${var.environment}-backend-ecr"
  }
}
