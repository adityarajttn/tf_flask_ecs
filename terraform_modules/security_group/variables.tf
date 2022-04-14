variable "name" {
  type = string
  description = "ECR repository name"
  default = "aws_ecs_flask"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 80
}

variable "vpc_id" {
  description = "The VPC ID"
}