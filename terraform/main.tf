# VPC
module "vpc" {
  source = "./modules/vpc"

  public_a_cidr = var.public_a_cidr
  public_b_cidr = var.public_b_cidr
  vpc_cidr = var.vpc_cidr
  private_a_cidr = var.private_a_cidr
  private_b_cidr = var.private_b_cidr
  project = var.project
  environment = var.environment
}

# IAM
module "iam" {
  source = "./modules/iam"

  environment = var.environment
  project = var.project
}

# SG
module "sg" {
  source = "./modules/sg"

  project = var.project
  environment = var.environment
  myIpAddress = var.myIpAddress
  vpc_id = module.vpc.vpc_id
}

# ALB
module "alb" {
  source = "./modules/alb"

  public_subnet_a_id = module.vpc.public_subnet_a_id
  public_subnet_b_id = module.vpc.public_subnet_b_id
  alb_sg_id = module.sg.alb_sg_id
  vpc_id = module.vpc.vpc_id
  environment = var.environment
  project = var.project

}

# ECR
module "ecr" {
  source = "./modules/ecr"

  project = var.project
  environment = var.environment
}

# ECS
module "ecs" {
  source = "./modules/ecs"

  environment = var.environment
  project = var.project
  private_subnet_a_id = module.vpc.private_subnet_a_id
  private_subnet_b_id = module.vpc.private_subnet_b_id
  target_group_arn = module.alb.target_group_arn
  task_execution_role_arn = module.iam.task_execution_role_arn
  frontend_ecr_url = module.ecr.frontend_ecr_url
  backend_ecr_url = module.ecr.backend_ecr_url
  frontend_url = var.frontend_url
  backend_url = var.backend_url
  ecs_sg_id = module.sg.ecs_sg_id
}


