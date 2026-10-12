variable "project_name" {
  description = "Nome do projeto usado como prefixo"
  type        = string
}

variable "github_org" {
  description = "Organizacao/dono do repositorio GitHub autorizado a assumir a role"
  type        = string
}

variable "github_repo" {
  description = "Nome do repositorio GitHub autorizado a assumir a role"
  type        = string
}

variable "aws_region" {
  description = "Regiao AWS dos repositorios ECR"
  type        = string
}

variable "ecr_repository_prefix" {
  description = "Prefixo dos repositorios ECR aos quais a role tera permissao de push"
  type        = string
  default     = "fiap"
}
