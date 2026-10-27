locals {
  oidc_provider = replace(aws_eks_cluster.main.identity[0].oidc[0].issuer, "https://", "")
  account_id    = data.aws_caller_identity.current.account_id
}
