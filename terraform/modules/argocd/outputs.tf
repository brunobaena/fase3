output "namespace" {
  value = helm_release.argocd.namespace
}

output "port_forward_command" {
  description = "Execute e acesse https://localhost:8080"
  value       = "kubectl -n ${helm_release.argocd.namespace} port-forward svc/argocd-server 8080:443"
}

output "initial_password_command" {
  description = "Retorna a senha inicial em base64 para decodificar localmente"
  value       = "kubectl -n ${helm_release.argocd.namespace} get secret argocd-initial-admin-secret -o jsonpath='{.data.password}'"
}
