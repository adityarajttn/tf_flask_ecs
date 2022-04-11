data "aws_ecr_repository" "ecr_repository" {
  name = var.ecr_repository_name
}

data "aws_ecr_image" "image_digest" {
  repository_name = var.ecr_repository_name
  image_tag       = "${var.app_image_tag}"
}

resource "aws_ecs_cluster" "main" {
  name = "flask_cluster"
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
      name      = "first"
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
  name            = var.ecr_repository_name
  network_configuration {
    subnets = ["subnet-0860e508a460a2165", "subnet-0e0ed15cbeac2634d", "subnet-00284896514456cf0"]
    assign_public_ip = true
  }
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"
}