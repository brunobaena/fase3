variable "namespace" {
  description = "Namespace de instalacao do metrics-server"
  type        = string
  default     = "kube-system"
}

variable "chart_version" {
  description = "Versao do chart Helm metrics-server"
  type        = string
  default     = "3.14.0"
}
