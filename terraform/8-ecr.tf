#Create ECR repository
#terraform aws create network load balancer
resource "aws_ecr_repository" "getscheduled-ecr-repository" {
  name                 = "getscheduled/service"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

