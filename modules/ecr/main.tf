resource "aws_ecr_repository" "periodic_table_repo" {
  name = "periodic-table-api-${var.env}"
  tags = {
    env = "${var.tag}"
  }
}

resource "aws_codebuild_project" "copy_temp_image" {
  name         = "copy-temp-image-${var.env}"
  service_role = var.codebuild_role

  source {
    type     = "NO_SOURCE"
    buildspec = <<EOF
      version: 0.2
      phases:
        build:
          commands:
            - aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${aws_ecr_repository.periodic_table_repo.repository_url}
            - docker pull public.ecr.aws/nginx/nginx:latest
            - docker tag public.ecr.aws/nginx/nginx:latest ${aws_ecr_repository.periodic_table_repo.repository_url}:latest
            - docker push ${aws_ecr_repository.periodic_table_repo.repository_url}:latest
      EOF
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image          = "aws/codebuild/standard:5.0"
    type           = "LINUX_CONTAINER"
    privileged_mode = true
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }
}

resource "aws_cloudwatch_event_rule" "trigger_codebuild" {
  name        = "trigger-codebuild-${var.env}"
  description = "Trigger CodeBuild when the project is created"

  event_pattern = jsonencode({
    source      = ["aws.codebuild"]
    detail-type = ["CodeBuild Build State Change"]
    detail = {
      "build-status" = ["SUCCEEDED"]
    }
  })
}

resource "aws_cloudwatch_event_target" "codebuild_target" {
  rule      = aws_cloudwatch_event_rule.trigger_codebuild.name
  target_id = "CodeBuildTarget"
  arn       = aws_codebuild_project.copy_temp_image.arn
  role_arn  = var.eventbridge_role
}