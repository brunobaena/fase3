# Reinicia os Deployments quando um Secret/ConfigMap referenciado muda (ex.: rotacao da senha do RDS
# propagada pelo External Secrets). Estrategia "annotations" porque o padrao (env-vars) injeta uma
# variavel no pod que o ArgoCD enxerga como drift e reverte com selfHeal.
resource "helm_release" "reloader" {
  name             = "reloader"
  repository       = "https://stakater.github.io/stakater-charts"
  chart            = "reloader"
  version          = var.chart_version != "" ? var.chart_version : null
  namespace        = var.namespace
  create_namespace = true

  atomic          = true
  cleanup_on_fail = true
  wait            = true
  timeout         = 300

  values = [yamlencode({
    reloader = {
      reloadStrategy = "annotations"
    }
  })]
}
