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
  default = "t3.medium"
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

variable "github_owner_id" {
  description = "ID numerico do owner GitHub (claim sub do token OIDC: repo:<org>@<owner_id>/<repo>@<repo_id>)"
  type        = string
}

variable "github_repo_id" {
  description = "ID numerico do repositorio GitHub (claim sub do token OIDC: repo:<org>@<owner_id>/<repo>@<repo_id>)"
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

variable "eks_admin_principal_arns" {
  description = "ARNs IAM (user ou role) com acesso de administrador ao cluster EKS"
  type        = list(string)
  default     = []
}

variable "terraform_role_arn" {
  description = "ARN IAM da role da pipeline. Vazio consulta a role criada pelo IAM bootstrap"
  type        = string
  default     = ""

  validation {
    condition     = var.terraform_role_arn == "" || can(regex("^arn:[a-z0-9-]+:iam::[0-9]{12}:role/.+$", var.terraform_role_arn))
    error_message = "terraform_role_arn deve ser um ARN de role IAM, nao de usuario root ou sessao STS."
  }
}

variable "eks_existing_pipeline_access" {
  description = "Indica que a entrada EKS da role da pipeline ja existe e deve ser adotada no apply"
  type        = bool
  default     = false
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
