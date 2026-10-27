# A role e criada pelo IAM bootstrap e independe da identidade que executa o Terraform.
data "aws_iam_role" "terraform" {
  count = var.terraform_role_arn == "" ? 1 : 0
  name  = "${var.project_name}-terraform-role"
}
