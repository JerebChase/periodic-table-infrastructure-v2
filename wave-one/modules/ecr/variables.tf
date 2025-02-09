variable "codebuild_role" {
  description = "The arn of the codebuild role"
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