variable "zone_id" {
  description = "The id of the cloudflare zone"
  type        = string
}

variable "certificate_validation_records" {
  description = "The list of certificate validation records for the app runner custom domain"
  type        = list
}

variable "backend_domain_target" {
  description = "The domain record for the apprunner service"
  type        = string
}

variable "backend_domain" {
  description = "The backend domain name"
  type        = string
}

variable "frontend_domain_target" {
  description = "The domain record for the cloudfront service"
  type        = string
}

variable "frontend_domain" {
  description = "The frontend domain name"
  type        = string
}

variable "env" {
    description = "The environment"
    type        = string
}