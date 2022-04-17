#Create ECS Cluster
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster
resource "aws_ecs_cluster" "getscheduled-cluster" {
  name = "GetScheduled-Cluster"

  configuration {
    execute_command_configuration {
      kms_key_id = aws_kms_key.getscheduled-kms-key.arn
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.getscheduled-logs.name
      }
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition
resource "aws_ecs_task_definition" "getscheduled-service" {
  family = "getscheduled-service"
  cpu = 256
  memory = 512
  requires_compatibilities = [ "FARGATE" ]
  network_mode = "awsvpc"
  execution_role_arn = "${aws_iam_role.ecs_service_role.arn}"
  task_role_arn = "${aws_iam_role.ecs-task-role.arn}"
  container_definitions = jsonencode([
    {
      name      = "GetScheduled-Service"
      image     = "${var.account_id}.dkr.ecr.${var.region}.amazonaws.com/getscheduled/service:latest"
      essential = true
      portMappings = [
        {
          containerPort = 8080,
          protocol = "http"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group = "getscheduled-logs",
          awslogs-region = "${var.region}",
          awslogs-stream-prefix = "awslogs-getscheduled-service"
        }
      }
    }
  ])

}
