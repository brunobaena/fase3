variable "aws_region" {
  description = "Regiao AWS"
  type        = string
  default     = "us-east-2"
}

variable "bucket_name" {
  description = "Nome do bucket S3 usado como backend remoto do Terraform"
  type        = string
  default     = "togglemaster-terraform-state"
}
