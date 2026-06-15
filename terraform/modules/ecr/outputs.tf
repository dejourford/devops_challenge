output "frontend_ecr_url" {
  value = aws_ecr_repository.frontend.repository_url
}

output "backend_ecr_url" {
  value = aws_ecr_repository.backend.repository_url
}

output "frontend_ecr_arn" {
  value = aws_ecr_repository.frontend.arn
}

output "backend_ecr_arn" {
  value = aws_ecr_repository.backend.arn
}
