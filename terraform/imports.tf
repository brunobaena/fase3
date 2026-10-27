import {
  for_each = var.eks_existing_pipeline_access ? toset([local.terraform_role_arn]) : toset([])

  to = module.eks.aws_eks_access_entry.admin[each.value]
  id = "${var.eks_cluster_name}:${each.value}"
}
