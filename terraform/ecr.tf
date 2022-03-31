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

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
    {
      "Sid": "AllowPushPull",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
         "REPLACE_ME_CODEBUILD_ROLE_ARN"
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
}
EOF
}