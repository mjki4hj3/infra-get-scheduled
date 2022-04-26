resource "aws_iam_role_policy" "ecs_service_role_policy" {
  name = "ecs_policy"
  role = aws_iam_role.ecs_service_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:AttachNetworkInterface",
          "ec2:CreateNetworkInterface",
          "ec2:CreateNetworkInterfacePermission",
          "ec2:DeleteNetworkInterface",
          "ec2:DeleteNetworkInterfacePermission",
          "ec2:Describe*",
          "ec2:DetachNetworkInterface",
          "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
          "elasticloadbalancing:DeregisterTargets",
          "elasticloadbalancing:Describe*",
          "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
          "elasticloadbalancing:RegisterTargets",
          "iam:PassRole",
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "logs:DescribeLogStreams",
          "logs:CreateLogStream",
          "logs:CreateLogGroup",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role" "ecs_service_role" {
  name = "ecs_service_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = [
            "ec2.amazonaws.com",
            "ecs-tasks.amazonaws.com"
          ]
        }
      },
    ]
  })
}


resource "aws_iam_role_policy" "ecs-task-role-policy" {
  name = "ecs_task"
  role = aws_iam_role.ecs-task-role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "logs:CreateLogStream",
          "logs:CreateLogGroup",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "dynamodb:Scan",
          "dynamodb:Query",
          "dynamodb:UpdateItem",
          "dynamodb:GetItem"
        ]
        Effect = "Allow"
        Resource = "arn:aws:dynamodb:*:*:table/GetScheduledTable*"
      }
    ]
  })
}

resource "aws_iam_role" "ecs-task-role" {
  name = "ecs_task_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = [
            "ecs-tasks.amazonaws.com"
          ]
        }
      },
    ]
  })
}

resource "aws_iam_role" "getscheduled-codepipeline-service-role" {
  name = "getscheduled_codepipeline_service_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = [
            "codepipeline.amazonaws.com"
          ]
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "getscheduled-codepipeline-service-role-policy" {
  name = "getscheduled_codepipeline_service_policy"
  role = aws_iam_role.getscheduled-codepipeline-service-role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "codecommit:GetBranch",
          "codecommit:GetCommit",
          "codecommit:UploadArchive",
          "codecommit:GetUploadArchiveStatus",
          "codecommit:CancelUploadArchive"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
           "s3:GetObjectVersion",
           "s3:GetBucketVersioning",
           "s3:GetObject"

        ]
        Effect = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "s3:PutObject"
        ]
        Effect = "Allow"
        Resource = "arn:aws:s3:::*"
      },
      {
        Action = [
          "elasticloadbalancing:*",
          "autoscaling:*",
          "cloudwatch:*",
          "ecs:*",
          "codebuild:*",
          "iam:PassRole"
        ]
        Effect = "Allow"
        Resource = "*"
      },
      
    ]
  })
}


resource "aws_iam_role_policy" "getscheduled-codebuild-service-role-policy" {
  name = "getscheduled_codebuild_service_policy"
  role = aws_iam_role.getscheduled-codebuild-service-role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "codecommit:ListBranches",
          "codecommit:ListRepositories",
          "codecommit:BatchGetRepositories",
          "codecommit:Get*",
          "codecommit:GitPull"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"

        ]
        Effect = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:ListBucket"

        ]
        Effect = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "ecr:InitiateLayerUpload",
          "ecr:GetAuthorizationToken"
        ]
        Effect = "Allow"
        Resource = "*"
      },
      
    ]
  })
}

resource "aws_iam_role" "getscheduled-codebuild-service-role" {
  name = "getscheduled_codebuild_service_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = [
            "codebuild.amazonaws.com"
          ]
        }
      },
    ]
  })
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

resource "aws_s3_bucket_policy" "allow_s3_access_from_codebuild_and_codepipline" {
  bucket = aws_s3_bucket.getscheduled-artifacts-bucket.id
  policy = jsonencode({
      "Statement": [
      {
        "Sid": "WhitelistedGet",
        "Effect": "Allow",
        "Principal": {
          "AWS": [
            "${aws_iam_role.getscheduled-codebuild-service-role.arn}",
            "${aws_iam_role.getscheduled-codepipeline-service-role.arn}",
          ]
        },
        "Action": [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketVersioning"
        ],
        "Resource": [
          "arn:aws:s3:::getscheduled-artifacts-bucket/*",
          "arn:aws:s3:::getscheduled-artifacts-bucket"
        ]
      },
      {
        "Sid": "WhitelistedPut",
        "Effect": "Allow",
        "Principal": {
          "AWS": [
            "${aws_iam_role.getscheduled-codebuild-service-role.arn}",
            "${aws_iam_role.getscheduled-codepipeline-service-role.arn}",
          ]
        },
        "Action": "s3:PutObject",
        "Resource": [
          "arn:aws:s3:::getscheduled-artifacts-bucket/*",
          "arn:aws:s3:::getscheduled-artifacts-bucket"
        ]
      }
    ]
  })

  depends_on = [
    aws_s3_bucket.getscheduled-artifacts-bucket
  ]
}


