output "auth_db_endpoint" {
  value = aws_db_instance.auth.endpoint
}

output "flags_db_endpoint" {
  value = aws_db_instance.flags.endpoint
}

output "targeting_db_endpoint" {
  value = aws_db_instance.targeting.endpoint
}

output "auth_db_secret_arn" {
  value = aws_db_instance.auth.master_user_secret[0].secret_arn
}

output "flags_db_secret_arn" {
  value = aws_db_instance.flags.master_user_secret[0].secret_arn
}

output "targeting_db_secret_arn" {
  value = aws_db_instance.targeting.master_user_secret[0].secret_arn
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
