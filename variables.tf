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

variable "name" {
  type = string
  description = "ECR repository name"
  default = "aws-ecs"
}

variable "image_tag" {
  type = string
  description = "Docker Image Tag"
  default = "v1"
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 3
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = 1024
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = 2048
}

variable "availability_zones" {
  description = "a comma-separated list of availability zones, defaults to all AZ of the region, if set to something other than the defaults, both private_subnets and public_subnets have to be defined as well"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "cidr" {
  description = "The CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "private_subnets" {
  description = "a list of CIDRs for private subnets in your VPC, must be set if the cidr variable is defined, needs to have as many elements as there are availability zones"
  default     = ["10.0.0.0/20", "10.0.32.0/20"]
}

variable "public_subnets" {
  description = "a list of CIDRs for public subnets in your VPC, must be set if the cidr variable is defined, needs to have as many elements as there are availability zones"
  default     = ["10.0.16.0/20", "10.0.48.0/20"]
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 80
}