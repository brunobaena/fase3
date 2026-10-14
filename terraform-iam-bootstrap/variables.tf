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
