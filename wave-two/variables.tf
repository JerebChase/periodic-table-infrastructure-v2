variable "backend_domain" {
  description = "The domain for the backend"
  type = string
}

variable "env" {
  description = "The environment in which to deploy (e.g., dev, prod)"
  type        = string
  default     = "dev"
}