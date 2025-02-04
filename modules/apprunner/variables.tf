variable "apprunner_role_arn" {
  description = "The arn of the apprunner execution role"
  type        = string
}

variable "ecr_repository_url" {
  description = "The url for the ecr repository"
  type        = string
}

variable "codebuild_run" {
  description = "The codebuild run that pushes a temp image to ECR"
  type = string
}

variable "tag" {
  description = "The tag to apply to AWS resources"
  type        = string
}

variable "env" {
  description = "The environment"
  type        = string
}