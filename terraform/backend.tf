terraform {
  backend "s3" {
    bucket       = "togglemaster-terraform-state"
    key          = "fase3/terraform.tfstate"
    region       = "us-east-2"
    use_lockfile = true
  }
}
