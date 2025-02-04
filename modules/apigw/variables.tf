variable "frontend_domain" {
  description = "The domain for the frontend"
  type        = string
}

variable "backend_domain" {
  description = "The domain for the backend"
  type        = string
}

variable "certificate_arn" {
  description = "The ARN of the certificate to use for HTTPS"
  type        = string
}

variable "apprunner_url" {
  description = "The url for the apprunner service"
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