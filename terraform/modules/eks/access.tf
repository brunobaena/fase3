# --- Acesso administrativo ao cluster via EKS Access Entries ---
# O cluster e criado pela role do GitHub Actions, que e a unica admin por padrao.
# Os principals listados aqui (usuarios ou roles IAM) tambem recebem admin do cluster,
# sem nenhum comando manual depois de recriar o cluster.
variable "admin_principal_arns" {
  description = "ARNs IAM (user ou role) com acesso de administrador ao cluster EKS"
  type        = list(string)
  default     = []
}

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
