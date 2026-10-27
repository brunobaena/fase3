data "tls_certificate" "github_actions" {
  url = "https://token.actions.githubusercontent.com"
}
