variable "project_name" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  description = "Subnets publicas onde o cluster e os nodes serao criados"
  type        = list(string)
}

variable "node_instance_type" {
  type = string
}

variable "node_desired" {
  type = number
}

variable "node_min" {
  type = number
}

variable "node_max" {
  type = number
}

variable "admin_principal_arns" {
  description = "ARNs IAM (user ou role) com acesso de administrador ao cluster EKS"
  type        = list(string)
  default     = []
}
