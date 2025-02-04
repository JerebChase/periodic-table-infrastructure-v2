output "apprunner_build_role" {
    description = "The arn of the apprunner execution role"
    value       = aws_iam_role.apprunner_build_role.arn
}

output "apprunner_execution_role" {
    description = "The arn of the apprunner execution role"
    value       = aws_iam_role.apprunner_execution_role.arn
}

output "codebuild_role" {
  description = "The arn of the codebuild role"
  value       = aws_iam_role.codebuild_role.arn
}