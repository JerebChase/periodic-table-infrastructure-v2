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

resource "aws_iam_role" "codebuild_role" {
  name = "CodeBuildECRRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "codebuild.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "codebuild_ecr_policy" {
  name        = "CodeBuildECRPolicy"
  description = "Allows CodeBuild to access ECR"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr-public:GetAuthorizationToken",
          "ecr-public:BatchGetImage",
          "ecr-public:GetRepositoryPolicy",
          "ecr-public:DescribeRepositories"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codebuild_ecr_attach" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.codebuild_ecr_policy.arn
}

resource "aws_iam_role" "eventbridge_role" {
  name = "EventBridgeCodeBuildRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "events.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "eventbridge_codebuild_policy" {
  name        = "EventBridgeCodeBuildPolicy"
  description = "Allows EventBridge to start CodeBuild projects"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = [
        "codebuild:StartBuild"
      ]
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eventbridge_codebuild_attach" {
  role       = aws_iam_role.eventbridge_role.name
  policy_arn = aws_iam_policy.eventbridge_codebuild_policy.arn
}