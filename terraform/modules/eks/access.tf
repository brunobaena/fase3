# --- Acesso administrativo ao cluster via EKS Access Entries ---

resource "aws_eks_access_entry" "admin" {
  for_each = toset(var.admin_principal_arns)

  cluster_name  = aws_eks_cluster.main.name
  principal_arn = each.value
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "admin" {
  for_each = toset(var.admin_principal_arns)

  cluster_name  = aws_eks_cluster.main.name
  principal_arn = aws_eks_access_entry.admin[each.key].principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}

# A API EKS pode confirmar a associacao antes de a autorizacao Kubernetes
# propagar. Os modulos Helm dependem do modulo EKS completo, incluindo esta espera.
resource "time_sleep" "access_propagation" {
  depends_on = [aws_eks_access_policy_association.admin]

  create_duration = "30s"

  triggers = {
    associations = jsonencode({
      for arn, association in aws_eks_access_policy_association.admin : arn => {
        associated_at = association.associated_at
        modified_at   = association.modified_at
      }
    })
  }
}
