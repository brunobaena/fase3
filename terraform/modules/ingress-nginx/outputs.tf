output "namespace" {
  value = helm_release.ingress_nginx.namespace
}

output "hostname" {
  description = "Hostname publico do load balancer compartilhado pelas APIs"
  value       = data.kubernetes_service_v1.controller.status[0].load_balancer[0].ingress[0].hostname
}

output "url" {
  description = "URL HTTP base das APIs pelo load balancer (sem TLS configurado nos Ingress)"
  value       = "http://${data.kubernetes_service_v1.controller.status[0].load_balancer[0].ingress[0].hostname}"
}

output "hostname_command" {
  description = "Mostra o hostname publico (NLB) por onde as APIs sao acessadas"
  value       = "kubectl -n ${helm_release.ingress_nginx.namespace} get svc ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'"
}
