data "aws_caller_identity" "current" {}

# --- OIDC Provider do GitHub Actions ---
data "aws_iam_openid_connect_provider" "github_actions" {
  url = "https://token.actions.githubusercontent.com"
}
