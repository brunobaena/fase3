variable "argocd_namespace" {
  description = "Namespace de instalacao do ArgoCD"
  type        = string
  default     = "argocd"
}

variable "argocd_chart_version" {
  description = "Versao fixa do chart Helm oficial do ArgoCD"
  type        = string
  default     = "10.9.2"
}

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

variable "vpc_cidr" {
  description = "CIDR da VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "AZs a usar"
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b"]
}

variable "eks_cluster_name" {
  description = "Nome do cluster EKS"
  type        = string
  default     = "togglemaster-eks"
}

variable "eks_cluster_version" {
  description = "Versao do Kubernetes"
  type        = string
  default     = "1.36"
}

variable "eks_node_instance_type" {
  type    = string
  default = "t3.small"
}

variable "eks_node_desired" {
  type    = number
  default = 2
}

variable "eks_node_min" {
  type    = number
  default = 1
}

variable "eks_node_max" {
  type    = number
  default = 5
}

variable "rds_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "rds_allocated_storage" {
  type    = number
  default = 20
}

variable "rds_engine_version" {
  description = "Versao do PostgreSQL"
  type        = string
  default     = "16"
}

variable "redis_node_type" {
  type    = string
  default = "cache.t3.micro"
}

variable "redis_engine_version" {
  type    = string
  default = "7.1"
}

variable "github_org" {
  description = "Organizacao/dono do repositorio GitHub autorizado a assumir a role via OIDC"
  type        = string
}

variable "github_repo" {
  description = "Nome do repositorio GitHub autorizado a assumir a role via OIDC"
  type        = string
}

variable "ecr_repositories" {
  description = "Lista de nomes dos repositorios ECR"
  type        = list(string)
  default = [
    "fiap/auth-service",
    "fiap/flags-service",
    "fiap/targeting-service",
    "fiap/evaluation-service",
    "fiap/analytics-service",
  ]
}
