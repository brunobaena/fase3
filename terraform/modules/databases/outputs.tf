output "auth_db_endpoint" {
  value = aws_db_instance.auth.endpoint
}

output "flags_db_endpoint" {
  value = aws_db_instance.flags.endpoint
}

output "targeting_db_endpoint" {
  value = aws_db_instance.targeting.endpoint
}

output "redis_endpoint" {
  value = aws_elasticache_cluster.redis.cache_nodes[0].address
}

output "redis_port" {
  value = aws_elasticache_cluster.redis.cache_nodes[0].port
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.analytics.name
}

output "dynamodb_table_arn" {
  value = aws_dynamodb_table.analytics.arn
}

output "rds_security_group_id" {
  value = aws_security_group.rds.id
}

output "redis_security_group_id" {
  value = aws_security_group.redis.id
}

output "db_secret_names" {
  description = "Nomes dos secrets (Secrets Manager) com credenciais e endpoint de cada banco"
  value       = { for k, v in aws_secretsmanager_secret.db : k => v.name }
}

output "auth_master_key_secret_name" {
  description = "Nome do secret com a MASTER_KEY do auth-service"
  value       = aws_secretsmanager_secret.auth_master_key.name
}
