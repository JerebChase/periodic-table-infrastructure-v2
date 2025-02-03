output "periodic_table_db_arn" {
    description = "The arn for the periodic table db"
    value       = aws_dynamodb_table.periodic_table_db.arn
}