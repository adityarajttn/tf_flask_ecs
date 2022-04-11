variable "ecr_repository_name" {
  type = string
  description = "ECR repository name"
}

variable "app_image_tag" {
  type = string
  description = "Docker Image Tag"
}

variable "app_image" {
  description = "Docker image to run in the ECS cluster"
  default     = "442803386520.dkr.ecr.us-east-1.amazonaws.com/aws_ecs_flask:latest"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 80
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = 1024
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = 2048
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 3
}