output "namespace" {
  value = helm_release.ingress_nginx.namespace
}

output "hostname_command" {
  description = "Mostra o hostname publico (NLB) por onde as APIs sao acessadas"
  value       = "kubectl -n ${helm_release.ingress_nginx.namespace} get svc ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'"
}
