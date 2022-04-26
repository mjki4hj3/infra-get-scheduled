# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codecommit_repository

resource "aws_codecommit_repository" "getscheduled-codecommit-repository" {
  repository_name = "GetScheduled-CodeCommit-Repository"
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project


resource "aws_codebuild_project" "getscheduled-codebuild-project" {

    name = "GetScheduled-CodeBuild-Project"

    artifacts {
      type = "NO_ARTIFACTS"
    }

    environment {
        compute_type = "BUILD_GENERAL1_SMALL"
        image = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
        privileged_mode = true
        type = "LINUX_CONTAINER"

        environment_variable {
                name = "AWS_ACCOUNT_ID"
                value = "${var.account_id}"
            }
        
        environment_variable {
                name = "AWS_DEFAULT_REGION"
                value = "${var.region}" 
            }
        
    }

    service_role = "${aws_iam_role.getscheduled-codebuild-service-role.arn}"
    source {
      type = "CODECOMMIT"
      location = "${aws_codecommit_repository.getscheduled-codecommit-repository.clone_url_http}"
    }

    depends_on = [
      aws_codecommit_repository.getscheduled-codecommit-repository
    ]
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline
# https://docs.aws.amazon.com/codepipeline/latest/userguide/reference-pipeline-structure.html#action-requirements

resource "aws_codepipeline" "getscheduled-codepipeline" {
  name = "GetScheduled-CodePipeline"
  role_arn = aws_iam_role.getscheduled-codepipeline-service-role.arn

  stage {
    name = "Source"
    action {
      name = "Source"
      category = "Source"
      owner = "AWS"
      version = "1"
      provider = "CodeCommit"
      
      output_artifacts = ["GetScheduled-Source-Artifact"]
      
      configuration = {
        RepositoryName = "${aws_codecommit_repository.getscheduled-codecommit-repository.repository_name}"
        BranchName = "master"
      }
      run_order = 1
    }
  }
    

  stage {
    name = "Build"
    action {
      name = "Build"
      category = "Build"
      owner = "AWS"
      version = "1"
      provider = "CodeBuild"
      
      output_artifacts = ["GetScheduled-Build-Artifact"]
      input_artifacts = ["GetScheduled-Source-Artifact"]
      configuration = {
        ProjectName = "${aws_codebuild_project.getscheduled-codebuild-project.name}"
      }
      run_order = 1
    }
    }

    stage {
        name = "Deploy"
        action{
            name = "Deploy"
            category = "Deploy"
            owner = "AWS"
            version = "1"
            provider = "ECS"
            
            input_artifacts = ["GetScheduled-Build-Artifact"]
            configuration = {
                ClusterName = "${aws_ecs_cluster.getscheduled-cluster.name}"
                ServiceName = "${aws_ecs_service.getscheduled-service-definition.name}"
                FileName = "imagedefinitions.json"
            }
            
        }
    }
    artifact_store {
      type = "S3"
    location = "${aws_s3_bucket.getscheduled-artifacts-bucket.bucket}"
    }
}


  
