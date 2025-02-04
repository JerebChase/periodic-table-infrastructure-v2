resource "aws_ecr_repository" "periodic_table_repo" {
  name = "periodic-table-api-${var.env}"
  tags = {
    env = "${var.tag}"
  }
}

resource "aws_codebuild_project" "copy_image_temp_image" {
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