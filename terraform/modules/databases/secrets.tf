# --- Enderecos publicados no AWS Secrets Manager (lidos pelo External Secrets) ---
# A SENHA dos bancos NAO fica aqui: o RDS a gera e rotaciona automaticamente
# (manage_master_user_password = true) num secret "rds!db-<uuid>" cujo nome muda a cada recriacao.
# O ExternalSecret de cada servico encontra esse secret pela tag aws:rds:primaryDBInstanceArn.
# Aqui ficam apenas dados nao sensiveis que nao mudam com a rotacao (host, porta, banco, usuario),
# em nomes estaveis (togglemaster/apps/...) que sobrevivem a destroy/rebuild.
# recovery_window_in_days = 0 evita conflito de nome ao recriar o ambiente.

locals {
  db_names = toset(["auth", "flags", "targeting"])

  db_instances = {
    auth      = aws_db_instance.auth
    flags     = aws_db_instance.flags
    targeting = aws_db_instance.targeting
  }
}

resource "aws_secretsmanager_secret" "db" {
  for_each = local.db_names

  name                    = "${var.project_name}/apps/${each.key}-service/db-endpoint"
  description             = "Endpoint do banco do ${each.key}-service (a senha fica no secret gerenciado pelo RDS)"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "db" {
  for_each = local.db_names

  secret_id = aws_secretsmanager_secret.db[each.key].id
  secret_string = jsonencode({
    username = local.db_instances[each.key].username
    host     = local.db_instances[each.key].address
    port     = tostring(local.db_instances[each.key].port)
    dbname   = local.db_instances[each.key].db_name
  })
}

resource "aws_secretsmanager_secret" "redis_url" {
  name                    = "${var.project_name}/apps/evaluation-service/redis-url"
  description             = "URL do ElastiCache Redis usada pelo evaluation-service"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "redis_url" {
  secret_id     = aws_secretsmanager_secret.redis_url.id
  secret_string = "redis://${aws_elasticache_cluster.redis.cache_nodes[0].address}:${aws_elasticache_cluster.redis.cache_nodes[0].port}"
}

resource "random_password" "auth_master_key" {
  length  = 32
  special = false
}

resource "aws_secretsmanager_secret" "auth_master_key" {
  name                    = "${var.project_name}/apps/auth-service/master-key"
  description             = "MASTER_KEY do auth-service (criacao de chaves de API)"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "auth_master_key" {
  secret_id     = aws_secretsmanager_secret.auth_master_key.id
  secret_string = random_password.auth_master_key.result
}
