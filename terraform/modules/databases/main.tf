resource "aws_security_group" "rds" {
  name_prefix = "${var.project_name}-rds-"
  vpc_id      = var.vpc_id
  description = "SG para instancias RDS PostgreSQL"

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.eks_cluster_security_group_id]
    description     = "PostgreSQL a partir dos nodes/pods do EKS"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-rds-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "redis" {
  name_prefix = "${var.project_name}-redis-"
  vpc_id      = var.vpc_id
  description = "SG para ElastiCache Redis"

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [var.eks_cluster_security_group_id]
    description     = "Redis a partir dos nodes/pods do EKS"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-redis-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

resource "aws_elasticache_subnet_group" "main" {
  name       = "${var.project_name}-cache-subnet-group"
  subnet_ids = var.private_subnet_ids
}

resource "aws_db_instance" "auth" {
  identifier                  = "auth-db"
  engine                      = "postgres"
  engine_version              = var.rds_engine_version
  instance_class              = var.rds_instance_class
  allocated_storage           = var.rds_allocated_storage
  storage_type                = "gp3"
  storage_encrypted           = true
  db_name                     = "postgres"
  username                    = "postgres"
  manage_master_user_password = true
  db_subnet_group_name        = aws_db_subnet_group.main.name
  vpc_security_group_ids      = [aws_security_group.rds.id]
  publicly_accessible         = false
  multi_az                    = false
  backup_retention_period     = 1
  skip_final_snapshot         = true
  apply_immediately           = true

  tags = {
    Name    = "auth-db"
    Service = "auth-service"
  }
}

resource "aws_db_instance" "flags" {
  identifier                  = "flags-db"
  engine                      = "postgres"
  engine_version              = var.rds_engine_version
  instance_class              = var.rds_instance_class
  allocated_storage           = var.rds_allocated_storage
  storage_type                = "gp3"
  storage_encrypted           = true
  db_name                     = "postgres"
  username                    = "postgres"
  manage_master_user_password = true
  db_subnet_group_name        = aws_db_subnet_group.main.name
  vpc_security_group_ids      = [aws_security_group.rds.id]
  publicly_accessible         = false
  multi_az                    = false
  backup_retention_period     = 1
  skip_final_snapshot         = true
  apply_immediately           = true

  tags = {
    Name    = "flags-db"
    Service = "flags-service"
  }
}

resource "aws_db_instance" "targeting" {
  identifier                  = "targeting-db"
  engine                      = "postgres"
  engine_version              = var.rds_engine_version
  instance_class              = var.rds_instance_class
  allocated_storage           = var.rds_allocated_storage
  storage_type                = "gp3"
  storage_encrypted           = true
  db_name                     = "postgres"
  username                    = "postgres"
  manage_master_user_password = true
  db_subnet_group_name        = aws_db_subnet_group.main.name
  vpc_security_group_ids      = [aws_security_group.rds.id]
  publicly_accessible         = false
  multi_az                    = false
  backup_retention_period     = 1
  skip_final_snapshot         = true
  apply_immediately           = true

  tags = {
    Name    = "targeting-db"
    Service = "targeting-service"
  }
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id         = "evaluation-cache"
  engine             = "redis"
  engine_version     = var.redis_engine_version
  node_type          = var.redis_node_type
  num_cache_nodes    = 1
  subnet_group_name  = aws_elasticache_subnet_group.main.name
  security_group_ids = [aws_security_group.redis.id]

  tags = {
    Name = "evaluation-cache"
  }
}

# Chave primaria alinhada ao analytics-service (app.py grava o item com "event_id" como chave).
resource "aws_dynamodb_table" "analytics" {
  name         = "ToggleMasterAnalytics"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "event_id"

  attribute {
    name = "event_id"
    type = "S"
  }

  tags = {
    Name = "ToggleMasterAnalytics"
  }
}
