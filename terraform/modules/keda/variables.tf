variable "namespace" {
  description = "Namespace de instalacao do KEDA"
  type        = string
  default     = "keda"
}

variable "chart_version" {
  description = "Versao do chart Helm keda (vazio = mais recente)"
  type        = string
  default     = ""
}

variable "service_account_name" {
  description = "Nome do ServiceAccount usado pelo keda-operator (deve bater com o IRSA)"
  type        = string
  default     = "keda-operator"
}

variable "role_arn" {
  description = "ARN da IAM Role IRSA (KEDA-SQS-Role) a anotar no ServiceAccount do keda-operator"
  type        = string
}
