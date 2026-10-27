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
