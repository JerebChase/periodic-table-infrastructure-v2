variable "env" {
  description = "The environment in which to deploy (e.g., dev, prod)"
  type        = string
  default     = "dev"
}

# variable "certificate_arn" {
#   description = "The ARN of the certificate to use for HTTPS"
#   type        = string
# }

# variable "frontend_domain" {
#   description = "The domain for the frontend"
#   type        = string
# }