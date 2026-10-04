variable "namespace" {
  description = "Namespace de instalacao do ArgoCD"
  type        = string
  default     = "argocd"
}

variable "chart_version" {
  description = "Versao do chart Helm argo-cd"
  type        = string
  default     = "10.9.2"
}
