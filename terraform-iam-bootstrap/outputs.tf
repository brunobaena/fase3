output "oidc_provider_arn" {
  description = "ARN do OIDC Provider do GitHub Actions"
  value       = aws_iam_openid_connect_provider.github_actions.arn
}

output "terraform_role_arn" {
  description = "ARN da role a ser registrada no secret AWS_ROLE_TERRAFORM do GitHub"
  value       = aws_iam_role.terraform.arn
}
