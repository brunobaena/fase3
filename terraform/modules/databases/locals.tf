locals {
  db_names = toset(["auth", "flags", "targeting"])

  db_instances = {
    auth      = aws_db_instance.auth
    flags     = aws_db_instance.flags
    targeting = aws_db_instance.targeting
  }
}
