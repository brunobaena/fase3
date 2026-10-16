output "namespace" {
  value = helm_release.argocd.namespace
}

output "port_forward_command" {
  description = "Execute e acesse https://localhost:8080"
  value       = "kubectl -n ${helm_release.argocd.namespace} port-forward svc/argocd-server 8080:443"
}

output "admin_password_command" {
  description = "Le a senha do usuario admin no Secrets Manager"
  value       = "aws secretsmanager get-secret-value --secret-id ${aws_secretsmanager_secret.admin_password.name} --region ${var.aws_region} --query SecretString --output text"
}

output "url_command" {
  description = "Mostra o endereco publico (hostname do NLB) do ArgoCD"
  value       = "kubectl -n ${helm_release.argocd.namespace} get svc argocd-server -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'"
}