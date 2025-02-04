output "apprunner_execution_role" {
    description = "The arn of the apprunner execution role"
    value       = aws_iam_role.apprunner_execution_role.arn
}

output "codebuild_role" {
  description = "The arn of the codebuild role"
  value       = aws_iam_role.codebuild_role.arn
}

output "eventbridge_role" {
  description = "The arn of the eventbridge role"
  value       = aws_iam_role.eventbridge_role.arn
}