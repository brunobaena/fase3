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

variable "apps_chart_version" {
  description = "Versao do chart Helm argocd-apps (declara as Applications)"
  type        = string
  default     = "2.0.6"
}

variable "project_name" {
  description = "Nome do projeto usado como prefixo do secret no Secrets Manager"
  type        = string
}

variable "aws_region" {
  description = "Regiao AWS (usada no comando de leitura da senha)"
  type        = string
  default     = "us-east-2"
}

variable "application_name" {
  description = "Nome da Application do ArgoCD"
  type        = string
  default     = "togglemaster"
}

variable "repo_url" {
  description = "URL HTTPS do repositorio Git observado pelo ArgoCD"
  type        = string
}

variable "repo_revision" {
  description = "Branch, tag ou commit observado"
  type        = string
  default     = "main"
}

variable "bootstrap_path" {
  description = "Pasta do repositorio com o ApplicationSet (gera uma Application por pasta de k8s/)"
  type        = string
  default     = "argocd"
}

variable "repo_username" {
  description = "Usuario para acessar o repositorio privado (com PAT como senha)"
  type        = string
  default     = "git"
}

variable "repo_token" {
  description = "PAT somente leitura do repositorio. Vazio = repositorio publico, sem credencial"
  type        = string
  sensitive   = true
  default     = ""
}

variable "allowed_cidrs" {
  description = "CIDRs autorizados a acessar o ArgoCD pelo load balancer"
  type        = list(string)
}
