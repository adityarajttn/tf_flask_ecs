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
  source = "./terraform_modules/ecs_service"
  ecr_repository_name = var.repository_name
  app_image_tag = var.image_tag
}