output "bucket_name" {
  description = "Nome do bucket S3 criado para o backend remoto"
  value       = aws_s3_bucket.tfstate.id
}

output "bucket_arn" {
  value = aws_s3_bucket.tfstate.arn
}
