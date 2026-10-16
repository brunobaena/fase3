variable "namespace" {
  description = "Namespace de instalacao do ingress-nginx"
  type        = string
  default     = "ingress-nginx"
}

variable "chart_version" {
  description = "Versao do chart Helm ingress-nginx (vazio = mais recente)"
  type        = string
  default     = ""
}
