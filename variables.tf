variable "region" {
  type = string
  default = "us-east-1"
  description = "AWS Reason"
}

variable "repository_name" {
  type = string
  description = "ECR repository name"
  default = "aws_ecs_flask"
}

variable "image_tag" {
  type = string
  description = "Docker Image Tag"
  default = "v1"
}