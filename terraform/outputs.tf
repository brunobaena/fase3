output "argocd_namespace" {
  value = module.argocd.namespace
}

output "argocd_port_forward_command" {
  value = module.argocd.port_forward_command
}

output "argocd_admin_password_command" {
  value = module.argocd.admin_password_command
}

output "eks_update_kubeconfig_command" {
  value = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
}

output "vpc_id" {
  value = module.networking.vpc_id
}

output "public_subnet_ids" {
  value = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.networking.private_subnet_ids
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

output "eso_role_arn" {
  value = module.eks.eso_role_arn
}

output "analytics_role_arn" {
  value = module.eks.analytics_role_arn
}

output "evaluation_role_arn" {
  value = module.eks.evaluation_role_arn
}

output "auth_db_endpoint" {
  value = module.databases.auth_db_endpoint
}

output "flags_db_endpoint" {
  value = module.databases.flags_db_endpoint
}

output "targeting_db_endpoint" {
  value = module.databases.targeting_db_endpoint
}

output "redis_endpoint" {
  value = module.databases.redis_endpoint
}

output "dynamodb_table_name" {
  value = module.databases.dynamodb_table_name
}

output "sqs_queue_url" {
  value = module.messaging.queue_url
}

output "ecr_repository_urls" {
  value = module.ecr.repository_urls
}

output "github_actions_role_arn" {
  description = "ARN a ser configurado no secret AWS_ROLE_TO_ASSUME do GitHub Actions"
  value       = module.github_actions_oidc.role_arn
}

output "ingress_hostname_command" {
  description = "Mostra o hostname publico (NLB) das APIs"
  value       = module.ingress_nginx.hostname_command
}

output "auth_master_key_command" {
  description = "Le a MASTER_KEY do auth-service (usada em teste-e2e.sh --master-key)"
  value       = "aws secretsmanager get-secret-value --secret-id ${module.databases.auth_master_key_secret_name} --region ${var.aws_region} --query SecretString --output text"
}
