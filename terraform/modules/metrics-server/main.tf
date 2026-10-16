terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
  }
}

# Expoe a Metrics API (metrics.k8s.io) usada pelo HPA do evaluation-service e pelo "kubectl top".
# O EKS nao instala o metrics-server por padrao. Instalado em kube-system (namespace ja existente).
resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  version    = var.chart_version
  namespace  = var.namespace

  atomic          = true
  cleanup_on_fail = true
  wait            = true
  timeout         = 300
}
