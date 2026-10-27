locals {
  github_sub_legacy   = "repo:${var.github_org}/${var.github_repo}:ref:refs/heads/main"
  github_sub_by_id    = var.github_owner_id != "" && var.github_repo_id != "" ? "repo:${var.github_org}@${var.github_owner_id}/${var.github_repo}@${var.github_repo_id}:ref:refs/heads/main" : ""
  github_sub_patterns = compact([local.github_sub_legacy, local.github_sub_by_id])
}
