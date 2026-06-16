output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "frontend_ecr_url" {
  value = module.ecr.frontend_ecr_url
}

output "backend_ecr_url" {
  value = module.ecr.backend_ecr_url
}

output "ecs_cluster_id" {
  value = module.ecs.cluster_id
}
