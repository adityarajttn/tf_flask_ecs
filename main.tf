#provider.aws
provider "aws" {
    region = var.region
}

#remote_state.s3
terraform {
  backend "s3" {
    bucket = "tf-cicd-ecs-bucket"
    key    = "terraform/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "tf-ecs-state-locking"
  }
}

module "ecs_app" {
  source = "./terraform_modules/ecs"
  ecr_repository_name         = var.repository_name
  app_image_tag               = var.image_tag
  app_count                   = var.app_count
  subnets                     = module.vpc.private_subnets
  aws_alb_target_group_arn    = module.alb.aws_alb_target_group_arn
  ecs_service_security_groups = [module.security_groups.ecs_tasks]
  app_port                    = var.app_port
  fargate_cpu                 = var.fargate_cpu
  fargate_memory              = var.fargate_memory
}

module "vpc" {
  source             = "./terraform_modules/vpc"
  cidr               = var.cidr
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  availability_zones = var.availability_zones
}

module "security_groups" {
  source         = "./terraform_modules/security_group"
  name           = var.repository_name
  vpc_id         = module.vpc.id
  app_port       = var.app_port
}

module "alb" {
  source              = "./terraform_modules/alb"
  name = var.name
  vpc_id              = module.vpc.id
  subnets             = module.vpc.public_subnets
  alb_security_groups = [module.security_groups.alb]
}