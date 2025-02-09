variable "env" {
  description = "The environment in which to deploy (e.g., dev, prod)"
  type        = string
  default     = "dev"
}

variable "zone_id" {
  description = "The id of the cloudflare zone"
  type        = string
}

variable "backend_domain" {
  description = "The domain for the backend"
  type = string
}

variable "frontend_domain" {
  description = "The domain for the frontend"
  type        = string
}