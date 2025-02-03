data "aws_iam_policy_document" "dynamodb_policy_json" {
  statement {
    effect    = "Allow"
    actions   = [
                  "dynamodb:GetItem",
                  "dynamodb:PutItem",
                  "dynamodb:UpdateItem",
                  "dynamodb:DeleteItem",
                  "dynamodb:Query",
                  "dynamodb:Scan"
                ]
    resources = [var.periodic_table_db_arn]
  }
}

resource "aws_iam_policy" "dynamodb_policy" {
  name        = "periodic-table-${var.env}-db-access-policy"
  description = "A policy to give the ECS task access to the DynamoDB table"
  policy      = data.aws_iam_policy_document.dynamodb_policy_json.json
}

resource "aws_iam_role" "apprunner_execution_role" {
  name = "periodic-table-apprunner-execution-role-${var.env}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "build.apprunner.amazonaws.com"
      }
    }]
  })

  tags = {
    env = "${var.tag}"
  }
}

resource "aws_iam_role_policy_attachment" "apprunner_ecr_policy" {
  role       = aws_iam_role.apprunner_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}

resource "aws_iam_role_policy_attachment" "dynamodb_access_policy" {
  role       = aws_iam_role.apprunner_execution_role.name
  policy_arn = aws_iam_policy.dynamodb_policy.arn
}