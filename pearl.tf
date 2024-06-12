provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIATTXHYADMB5HXCBOM"
  secret_key = "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"
}

resource "aws_ecs_cluster" "my_cluster" {
  name = "my-ecs-cluster"
}

resource "aws_ecs_task_definition" "my_task_definition" {
  family       = "my-task-def"
  network_mode = "awsvpc"

  container_definitions = jsonencode([
    {
      name      = "my-app-container"
      image     = "nginx:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80,
          hostPort      = 80
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "my_ecs_service" {
  name            = "my-ecs-service"
  cluster         = "aws_ecs_cluster_my_cluster.id"
  task_definition = "aws_ecs_task_definition.my_task_definition.arn"

  launch_type = "FARGATE"

  network_configuration {
    subnets          = ["subnet-051cfc09d5545071c"]
    security_groups  = ["sg-02ed44cda35d0d58e"]
    assign_public_ip = true
  }

  depends_on = [
    aws_ecs_task_definition.my_task_definition
  ]
}