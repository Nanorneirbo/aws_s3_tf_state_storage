

resource "aws_s3_bucket" "nanos-terraform-bucket" {

  bucket = "nanos-terraform-bucket"

  lifecycle {
    prevent_destroy = true
  }

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name = "terrafrom-up-and-runing-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

}


terraform {
  backend "s3" {
    bucket = "nanos-terraform-bucket"
    key = "terraform/terraform.tfstate"
    region = "eu-west-1"

    dynamodb_table = "terraform-up-and-running-locks"
    encrypt = true

    access_key =
    secret_key =
  }

}

output "s3_bucket-arn" {
  value = aws_s3_bucket.nanos-terraform-bucket.arn
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_locks.name
}