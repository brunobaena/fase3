variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "rds_instance_class" {
  type = string
}

variable "rds_allocated_storage" {
  type = number
}

variable "rds_engine_version" {
  type = string
}

variable "redis_node_type" {
  type = string
}

variable "redis_engine_version" {
  type = string
}

variable "eks_cluster_security_group_id" {
  description = "Security group do cluster EKS, usado para liberar acesso as bases de dados"
  type        = string
}
