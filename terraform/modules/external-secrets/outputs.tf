output "namespace" {
  value = helm_release.external_secrets.namespace
}

output "service_account_name" {
  value = var.service_account_name
}
