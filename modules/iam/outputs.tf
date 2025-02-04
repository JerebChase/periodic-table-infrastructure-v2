output "apprunner_execution_role" {
    description = "The arn of the apprunner execution role"
    value       = aws_iam_role.apprunner_execution_role.arn
}