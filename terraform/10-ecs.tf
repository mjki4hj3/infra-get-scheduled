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
resource "aws_ecs_task_definition" "getscheduled-task-definition" {
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

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service
resource "aws_ecs_service" "getscheduled-service-definition" {
  name = "GetScheduled-Service"
  cluster = aws_ecs_cluster.getscheduled-cluster.id
  task_definition = aws_ecs_task_definition.getscheduled-task-definition.arn
  launch_type = "FARGATE"
  desired_count = 1

  deployment_maximum_percent = 200
  deployment_minimum_healthy_percent = 0

  network_configuration {
    assign_public_ip = false
    subnets = ["${aws_subnet.private-subnet-one.id}", "${aws_subnet.private-subnet-two.id}"]
    security_groups = ["${aws_security_group.FargateContainerSecurityGroup.id}"]
  }

  load_balancer {

    container_name = "GetScheduled-Service"
    container_port = 8080
    target_group_arn = aws_lb_target_group.getscheduled_target_group.arn
  }
  
}


