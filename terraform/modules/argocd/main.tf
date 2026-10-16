terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

locals {
  # Credencial do repositorio: so e criada quando repo_token e informado (repositorio privado).
  repositories = {
    for name in [var.application_name] : name => {
      url      = var.repo_url
      name     = var.application_name
      type     = "git"
      username = var.repo_username
      password = var.repo_token
    } if var.repo_token != ""
  }
}

# --- Senha do admin: gerada pelo Terraform e guardada no Secrets Manager ---
resource "random_password" "admin" {
  length  = 24
  special = false
}

# bcrypt() gera um hash diferente a cada avaliacao; o ignore_changes evita diff permanente
# no helm_release. O hash so e recalculado quando a senha muda (triggers_replace).
resource "terraform_data" "admin_password_hash" {
  triggers_replace = [random_password.admin.result]
  input            = bcrypt(random_password.admin.result)

  lifecycle {
    ignore_changes = [input]
  }
}

# recovery_window_in_days = 0 permite destruir e recriar o cluster sem conflito de nome.
resource "aws_secretsmanager_secret" "admin_password" {
  name                    = "${var.project_name}/argocd-admin-password"
  description             = "Senha do usuario admin do ArgoCD (gerada pelo Terraform)"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "admin_password" {
  secret_id     = aws_secretsmanager_secret.admin_password.id
  secret_string = random_password.admin.result
}

# --- ArgoCD ---
resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = var.chart_version
  namespace        = var.namespace
  create_namespace = true

  atomic          = true
  cleanup_on_fail = true
  wait            = true
  timeout         = 900

  values = [yamlencode({
    fullnameOverride = "argocd"
    server = {
      service = {
        type                     = "LoadBalancer"
        loadBalancerSourceRanges = var.allowed_cidrs
        annotations = {
          "service.beta.kubernetes.io/aws-load-balancer-type" = "nlb"
        }
      }
    }
    configs = {
      secret = {
        argocdServerAdminPassword      = terraform_data.admin_password_hash.output
        argocdServerAdminPasswordMtime = "2026-01-01T00:00:00Z"
      }
      repositories = local.repositories
    }
  })]
}

# --- Bootstrap (GitOps): uma unica Application que aplica argocd/applicationset.yaml do repositorio ---
# O ApplicationSet gera uma Application por pasta de k8s/ (platform, auth-service, ...).
# Instalada pelo chart oficial argocd-apps, depois que os CRDs do ArgoCD ja existem.
resource "helm_release" "argocd_apps" {
  name       = "argocd-apps"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-apps"
  version    = var.apps_chart_version
  namespace  = helm_release.argocd.namespace

  atomic          = true
  cleanup_on_fail = true
  wait            = true
  timeout         = 300

  values = [yamlencode({
    applications = {
      "${var.application_name}-bootstrap" = {
        namespace  = helm_release.argocd.namespace
        finalizers = ["resources-finalizer.argocd.argoproj.io"]
        project    = "default"
        source = {
          repoURL        = var.repo_url
          targetRevision = var.repo_revision
          path           = var.bootstrap_path
        }
        destination = {
          server    = "https://kubernetes.default.svc"
          namespace = helm_release.argocd.namespace
        }
        syncPolicy = {
          automated = {
            prune    = true
            selfHeal = true
          }
        }
      }
    }
  })]
}
