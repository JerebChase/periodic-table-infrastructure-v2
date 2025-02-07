variable "apprunner_build_role" {
  description = "The arn of the apprunner build role"
  type        = string
}

variable "apprunner_execution_role" {
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

variable "backend_domain" {
  description = "The domain for the backend"
  type = string
}

variable "zone_id" {
  description = "The id of the cloudflare zone"
  type        = string
}
 
variable "tag" {
  description = "The tag to apply to AWS resources"
  type        = string
}

variable "env" {
  description = "The environment"
  type        = string
}