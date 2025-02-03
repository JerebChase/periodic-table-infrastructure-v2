output "ecs_task_role_arn" {
    description = "The arn of the ecs task execution role"
    value       = aws_iam_role.ecs_task_execution_role.arn
}