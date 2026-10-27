locals {
  # Nomes de bucket S3 sao unicos globalmente entre TODAS as contas AWS,
  # por isso o account id e usado como sufixo para evitar colisao com
  # buckets de mesmo nome criados por outras contas.
  bucket_name = "${var.bucket_name}-${data.aws_caller_identity.current.account_id}"
}
