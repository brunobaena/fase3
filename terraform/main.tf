module "networking" {
  source = "./modules/networking"

  project_name       = var.project_name
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
}

module "eks" {
  source = "./modules/eks"

  project_name       = var.project_name
  cluster_name       = var.eks_cluster_name
  cluster_version    = var.eks_cluster_version
  vpc_id             = module.networking.vpc_id
  subnet_ids         = module.networking.public_subnet_ids
  node_instance_type = var.eks_node_instance_type
  node_desired       = var.eks_node_desired
  node_min           = var.eks_node_min
  node_max           = var.eks_node_max
}

module "databases" {
  source = "./modules/databases"

  project_name                  = var.project_name
  vpc_id                        = module.networking.vpc_id
  private_subnet_ids            = module.networking.private_subnet_ids
  rds_instance_class            = var.rds_instance_class
  rds_allocated_storage         = var.rds_allocated_storage
  rds_engine_version            = var.rds_engine_version
  redis_node_type               = var.redis_node_type
  redis_engine_version          = var.redis_engine_version
  eks_cluster_security_group_id = module.eks.cluster_security_group_id
}

module "messaging" {
  source = "./modules/messaging"

  project_name = var.project_name
}

module "ecr" {
  source = "./modules/ecr"

  repository_names = var.ecr_repositories
}

module "github_actions_oidc" {
  source = "./modules/github-actions-oidc"

  project_name = var.project_name
  github_org   = var.github_org
  github_repo  = var.github_repo
  aws_region   = var.aws_region
}

module "argocd" {
  source = "./modules/argocd"

  namespace     = var.argocd_namespace
  chart_version = var.argocd_chart_version

  depends_on = [module.eks]
}
