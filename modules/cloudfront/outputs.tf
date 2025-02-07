output "frontend_domain_target" {
  description = "The domain record for the cloudfront distribution"
  value       = aws_cloudfront_distribution.website_distribution.domain_name
}