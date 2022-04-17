#Create ECR repository
#terraform aws create network load balancer
resource "aws_ecr_repository" "getscheduled-ecr-repository" {
  name                 = "getscheduled/service"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository_policy" "getscheduled-ecr-repository-policy" {
  repository = aws_ecr_repository.getscheduled-ecr-repository.name

  policy = jsonencode({
    "Version": "2008-10-17",
    "Statement": [
    {
      "Sid": "AllowPushPull",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
         "${aws_iam_role.getscheduled-codebuild-service-role.arn}"
        ]
      },
      "Action": [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability",
        "ecr:PutImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload"
      ]
    }
  ]
  })
}