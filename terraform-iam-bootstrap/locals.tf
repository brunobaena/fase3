locals {
  # Role com AdministratorAccess: so execucoes na branch main (push e workflow_dispatch a partir da main).
  # O token do GitHub traz o sub com IDs (repo:org@owner_id/repo@repo_id:ref:refs/heads/main); o formato
  # sem IDs fica como compatibilidade.
  github_sub_legacy   = "repo:${var.github_org}/${var.github_repo}:ref:refs/heads/main"
  github_sub_by_id    = var.github_owner_id != "" && var.github_repo_id != "" ? "repo:${var.github_org}@${var.github_owner_id}/${var.github_repo}@${var.github_repo_id}:ref:refs/heads/main" : ""
  github_sub_patterns = compact([local.github_sub_legacy, local.github_sub_by_id])
}
