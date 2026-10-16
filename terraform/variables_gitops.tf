variable "eks_admin_principal_arns" {
  description = "ARNs IAM (user ou role) com acesso de administrador ao cluster EKS"
  type        = list(string)
  default     = []
}

variable "argocd_repo_token" {
  description = "PAT somente leitura do repositorio (necessario apenas se o repositorio for privado)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "argocd_allowed_cidrs" {
  description = "CIDRs autorizados a acessar o ArgoCD (ex.: [\"203.0.113.10/32\"])"
  type        = list(string)

  validation {
    condition     = length(var.argocd_allowed_cidrs) > 0
    error_message = "Informe ao menos um CIDR em argocd_allowed_cidrs para nao expor o ArgoCD a internet."
  }
}
