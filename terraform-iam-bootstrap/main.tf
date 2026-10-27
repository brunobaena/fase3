# --- OIDC Provider do GitHub Actions (identidade raiz usada por toda a automacao) ---
resource "aws_iam_openid_connect_provider" "github_actions" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.github_actions.certificates[0].sha1_fingerprint]
}

# --- IAM Role usada pela pipeline terraform-ci.yml para aplicar o Terraform principal ---
resource "aws_iam_role" "terraform" {
  name = "${var.project_name}-terraform-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Federated = aws_iam_openid_connect_provider.github_actions.arn }
      Action    = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
        }
        StringLike = {
          "token.actions.githubusercontent.com:sub" = local.github_sub_patterns
        }
      }
    }]
  })

  tags = {
    Name    = "${var.project_name}-terraform-role"
    Purpose = "Execucao do Terraform via GitHub Actions OIDC"
  }
}

# Permissoes amplas: esta role provisiona VPC, EKS, RDS, IAM, DynamoDB, SQS, ECR e o backend S3.
resource "aws_iam_role_policy_attachment" "terraform_admin" {
  role       = aws_iam_role.terraform.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
