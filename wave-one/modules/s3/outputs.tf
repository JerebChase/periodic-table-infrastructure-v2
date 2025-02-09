output "periodic_table_s3_bucket" {
    description = "The id for the periodic table upload bucket"
    value       = aws_s3_bucket.periodic_table_bucket.id
}

output "periodic_table_bucket_endpoint" {
    description = "The website endpoint for the periodic table upload bucket"
    value       = aws_s3_bucket_website_configuration.periodic_table_bucket_website_config.website_endpoint
}