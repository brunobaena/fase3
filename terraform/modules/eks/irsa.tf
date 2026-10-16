locals {
  oidc_provider = replace(aws_eks_cluster.main.identity[0].oidc[0].issuer, "https://", "")
  account_id    = data.aws_caller_identity.current.account_id
}

# --- IRSA: External Secrets Operator ---
resource "aws_iam_role" "eso" {
  name = "ToggleMaster-ESO-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Federated = aws_iam_openid_connect_provider.eks.arn }
      Action    = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${local.oidc_provider}:sub" = "system:serviceaccount:external-secrets:external-secrets-sa"
          "${local.oidc_provider}:aud" = "sts.amazonaws.com"
        }
      }
    }]
  })
}

resource "aws_iam_policy" "eso" {
  name = "ToggleMaster-ESO-SecretsManagerPolicy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        # ListSecrets e BatchGetSecretValue nao suportam restricao por recurso.
        Sid      = "ListAndBatchGet"
        Effect   = "Allow"
        Action   = ["secretsmanager:ListSecrets", "secretsmanager:BatchGetSecretValue"]
        Resource = "*"
      },
      {
        Sid    = "ReadAppAndRdsSecrets"
        Effect = "Allow"
        Action = ["secretsmanager:GetSecretValue", "secretsmanager:DescribeSecret"]
        Resource = [
          "arn:aws:secretsmanager:us-east-2:${local.account_id}:secret:${var.project_name}/apps/*",
          "arn:aws:secretsmanager:us-east-2:${local.account_id}:secret:rds!db-*",
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eso" {
  role       = aws_iam_role.eso.name
  policy_arn = aws_iam_policy.eso.arn
}

# --- IRSA: Analytics Service (DynamoDB + SQS) ---
resource "aws_iam_role" "analytics" {
  name = "ToggleMaster-Analytics-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Federated = aws_iam_openid_connect_provider.eks.arn }
      Action    = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${local.oidc_provider}:sub" = "system:serviceaccount:analytics:analytics-service-sa"
          "${local.oidc_provider}:aud" = "sts.amazonaws.com"
        }
      }
    }]
  })
}

resource "aws_iam_policy" "analytics" {
  name = "ToggleMaster-Analytics-DynamoSQSPolicy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DynamoDBAccess"
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem", "dynamodb:GetItem", "dynamodb:UpdateItem", "dynamodb:DeleteItem",
          "dynamodb:Query", "dynamodb:Scan", "dynamodb:BatchWriteItem", "dynamodb:BatchGetItem",
          "dynamodb:DescribeTable"
        ]
        Resource = [
          "arn:aws:dynamodb:us-east-2:${local.account_id}:table/ToggleMasterAnalytics",
          "arn:aws:dynamodb:us-east-2:${local.account_id}:table/ToggleMasterAnalytics/index/*"
        ]
      },
      {
        Sid      = "SQSAccess"
        Effect   = "Allow"
        Action   = ["sqs:SendMessage", "sqs:ReceiveMessage", "sqs:DeleteMessage", "sqs:GetQueueAttributes", "sqs:GetQueueUrl", "sqs:ChangeMessageVisibility"]
        Resource = "arn:aws:sqs:us-east-2:${local.account_id}:toogle-master-queue"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "analytics" {
  role       = aws_iam_role.analytics.name
  policy_arn = aws_iam_policy.analytics.arn
}

# --- IRSA: Evaluation Service (SQS) ---
resource "aws_iam_role" "evaluation" {
  name = "ToggleMaster-Evaluation-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Federated = aws_iam_openid_connect_provider.eks.arn }
      Action    = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${local.oidc_provider}:sub" = "system:serviceaccount:evaluation:evaluation-service-sa"
          "${local.oidc_provider}:aud" = "sts.amazonaws.com"
        }
      }
    }]
  })
}

resource "aws_iam_policy" "evaluation" {
  name = "ToggleMaster-Evaluation-SQSPolicy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["sqs:SendMessage", "sqs:GetQueueAttributes", "sqs:GetQueueUrl"]
      Resource = "arn:aws:sqs:us-east-2:${local.account_id}:toogle-master-queue"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "evaluation" {
  role       = aws_iam_role.evaluation.name
  policy_arn = aws_iam_policy.evaluation.arn
}

# --- IRSA: KEDA Operator (leitura do queueDepth da fila SQS) ---
resource "aws_iam_role" "keda" {
  name = "KEDA-SQS-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Federated = aws_iam_openid_connect_provider.eks.arn }
      Action    = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${local.oidc_provider}:sub" = "system:serviceaccount:keda:keda-operator"
          "${local.oidc_provider}:aud" = "sts.amazonaws.com"
        }
      }
    }]
  })
}

resource "aws_iam_policy" "keda" {
  name = "KEDA-SQS-ReadPolicy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid      = "KEDASQSRead"
      Effect   = "Allow"
      Action   = ["sqs:GetQueueAttributes", "sqs:GetQueueUrl"]
      Resource = "arn:aws:sqs:us-east-2:${local.account_id}:toogle-master-queue"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "keda" {
  role       = aws_iam_role.keda.name
  policy_arn = aws_iam_policy.keda.arn
}
