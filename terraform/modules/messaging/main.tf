resource "aws_sqs_queue" "main" {
  name                       = "toogle-master-queue"
  visibility_timeout_seconds = 30
  message_retention_seconds  = 345600
  receive_wait_time_seconds  = 10

  tags = {
    Name    = "toogle-master-queue"
    Project = var.project_name
  }
}
