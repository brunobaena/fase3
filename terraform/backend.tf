terraform {
  # O nome do bucket inclui o account id (ver terraform-bootstrap/main.tf) e so
  # e conhecido em tempo de execucao, por isso o backend e parcial: o valor de
  # "bucket" e passado via -backend-config na hora do "terraform init".
  # Local:  terraform init -backend-config="bucket=togglemaster-terraform-state-<ACCOUNT_ID>"
  # Pipeline: ver step "Init" em .github/workflows/terraform-ci.yml
  backend "s3" {
    key          = "fase3/terraform.tfstate"
    region       = "us-east-2"
    use_lockfile = true
  }
}
