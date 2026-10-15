variable "namespace" {
  description = "Namespace de instalacao do External Secrets Operator"
  type        = string
  default     = "external-secrets"
}

variable "chart_version" {
  description = "Versao do chart Helm external-secrets"
  type        = string
  default     = ""
}

variable "service_account_name" {
  description = "Nome do ServiceAccount usado pelo ESO (deve bater com o IRSA e o ClusterSecretStore)"
  type        = string
  default     = "external-secrets-sa"
}

variable "role_arn" {
  description = "ARN da IAM Role IRSA (ToggleMaster-ESO-Role) a anotar no ServiceAccount"
  type        = string
}
