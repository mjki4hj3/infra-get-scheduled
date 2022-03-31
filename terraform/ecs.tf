#Create ECS Cluster
#terraform aws create ecs
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

#terraform aws create ecs task definition
resource "aws_ecs_task_definition" "getscheduled-service" {
  family = "getscheduled-service"
  cpu = 256
  memory = 512
  requires_compatibilities = [ "FARGATE" ]
  network_mode = "awsvpc"
  execution_role_arn = "FUTURE_REFERENCE_ECS_SERVICE_ROLE_ARN"
  task_role_arn = "FUTURE_REFERENCE_ECS_TASK_ROLE_ARN"
  container_definitions = jsonencode([
    {
      name      = "GetScheduled-Service"
      image     = "${var.ACCOUNT_ID}.dkr.ecr.${var.}.amazonaws.com/getscheduled/service:latest"
      essential = true
      portMappings = [
        {
          containerPort = 8080,
          protocol = "http"
        }
      ]
    }
  ])

}
