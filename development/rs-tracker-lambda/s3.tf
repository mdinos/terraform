resource "aws_s3_bucket" "lambda_s3_bucket" {
  bucket = "${var.lambda_name}"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags {
    Name = "${var.lambda_name}"
  }
}
