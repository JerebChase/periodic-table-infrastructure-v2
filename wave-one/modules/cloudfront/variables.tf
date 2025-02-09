variable "periodic_table_bucket_endpoint" {
    description = "The endpoint for s3 bucket website"
    type        = string
}

variable "certificate_arn" {
    description = "The ARN of the certificate to use for HTTPS"
    type        = string
}

variable "frontend_domain" {
    description = "The domain for the frontend"
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