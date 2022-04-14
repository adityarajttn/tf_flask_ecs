data "aws_ecr_repository" "ecr_repository" {
  name = var.ecr_repository_name
}

data "aws_ecr_image" "image_digest" {
  repository_name = var.ecr_repository_name
  image_tag       = "${var.app_image_tag}"
}

resource "aws_ecs_cluster" "main" {
  name = "${var.ecr_repository_name}-cluster"
}

resource "aws_ecs_task_definition" "app" {
  family = "service"
  execution_role_arn       = aws_iam_role.ecs_task_role.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions = jsonencode([
    {
      name      = "${var.ecr_repository_name}-container"
      image     = "${data.aws_ecr_repository.ecr_repository.repository_url}@${data.aws_ecr_image.image_digest.image_digest}"
      essential = true
      portMappings = [
        {
          containerPort = var.app_port
          hostPort      = var.app_port
        }
      ]
    }
  ])

}

resource "aws_ecs_service" "service" {
  name            = "${var.ecr_repository_name}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
   security_groups  = var.ecs_service_security_groups
   subnets          = var.subnets.*.id
   assign_public_ip = true
 }
 
 load_balancer {
   target_group_arn = var.aws_alb_target_group_arn
   container_name   = "${var.ecr_repository_name}-container"
   container_port   = var.app_port
 }
 
 lifecycle {
   ignore_changes = [task_definition, desired_count]
 }
}
