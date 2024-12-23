data "aws_s3_bucket" "terraform_state" {
  bucket = "pavan-terraform-state"  # The name of the existing bucket
}

# Enable Versioning for S3 bucket
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = data.aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable Encryption for S3 bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = data.aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block Public Access for S3 bucket
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket                  = data.aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_dynamodb_table" "terraform_state" {
  name = "terraform-state"  # The name of the existing DynamoDB table
}
