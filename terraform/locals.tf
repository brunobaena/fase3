locals {
  terraform_role_arn = var.terraform_role_arn != "" ? var.terraform_role_arn : data.aws_iam_role.terraform[0].arn

  eks_admin_principal_arns = setunion(
    toset(var.eks_admin_principal_arns),
    toset([local.terraform_role_arn]),
  )
}
