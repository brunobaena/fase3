variable "namespace" {
  description = "Namespace de instalacao do Reloader"
  type        = string
  default     = "reloader"
}

variable "chart_version" {
  description = "Versao do chart Helm reloader (vazio = mais recente; fixe uma versao depois do primeiro apply)"
  type        = string
  default     = ""
}
