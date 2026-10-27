resource "helm_release" "keda" {
  name             = "keda"
  repository       = "https://kedacore.github.io/charts"
  chart            = "keda"
  version          = var.chart_version != "" ? var.chart_version : null
  namespace        = var.namespace
  create_namespace = true

  atomic          = true
  cleanup_on_fail = true
  wait            = true
  timeout         = 300

  set = [
    {
      name  = "watchNamespace"
      value = ""
    },
    {
      name  = "serviceAccount.operator.name"
      value = var.service_account_name
    },
    {
      name  = "podIdentity.aws.irsa.enabled"
      value = "true"
    },
    {
      name  = "podIdentity.aws.irsa.roleArn"
      value = var.role_arn
    }
  ]
}
