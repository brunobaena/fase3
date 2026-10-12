output "role_arn" {
  description = "ARN da role a ser usada no secret AWS_ROLE_TO_ASSUME do GitHub Actions"
  value       = aws_iam_role.github_actions.arn
}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.github_actions.arn
}
