variable "aws_region" {
  description = "Regiao AWS"
  type        = string
  default     = "us-east-2"
}

variable "project_name" {
  description = "Nome do projeto usado como prefixo"
  type        = string
  default     = "togglemaster"
}

variable "github_org" {
  description = "Organizacao/dono do repositorio GitHub autorizado a assumir a role via OIDC"
  type        = string
  default     = "brunobaena"
}

variable "github_repo" {
  description = "Nome do repositorio GitHub autorizado a assumir a role via OIDC"
  type        = string
  default     = "fase3"
}

variable "github_owner_id" {
  description = "ID numerico do owner GitHub (claim sub do token OIDC: repo:<org>@<owner_id>/<repo>@<repo_id>)"
  type        = string
  default     = "17412834"
}

variable "github_repo_id" {
  description = "ID numerico do repositorio GitHub (claim sub do token OIDC: repo:<org>@<owner_id>/<repo>@<repo_id>)"
  type        = string
  default     = "1382535548"
}
