# O Helm aguarda a criacao do load balancer antes de consultar o Service.
data "kubernetes_service_v1" "controller" {
  metadata {
    name      = "${helm_release.ingress_nginx.name}-controller"
    namespace = helm_release.ingress_nginx.namespace
  }

  depends_on = [helm_release.ingress_nginx]
}
