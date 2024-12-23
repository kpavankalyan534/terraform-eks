# 1. Create the S3 Bucket for Terraform state storage
resource "aws_s3_bucket" "terraform_state" {
  bucket = "pavan-terraform-state"  # Change this to a unique name

  lifecycle {
    prevent_destroy = true
  }
}

# 2. Enable Versioning on the S3 Bucket
resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# 3. Enable Encryption on the S3 Bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# 4. Block Public Access on the S3 Bucket
resource "aws_s3_bucket_public_access_block" "terraform_state_public_access_block" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 5. Create the DynamoDB Table for State Locking
resource "aws_dynamodb_table" "terraform_state" {
  name         = "terraform-state"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

# 6. Use local-exec provisioner to reinitialize Terraform backend after provisioning
resource "null_resource" "backend_init" {
  depends_on = [
    aws_s3_bucket.terraform_state,
    aws_dynamodb_table.terraform_state
  ]

  provisioner "local-exec" {
    command = "terraform init -backend-config=\"bucket=${aws_s3_bucket.terraform_state.bucket}\" -backend-config=\"key=global/s3/terraform.tfstate\" -backend-config=\"region=ap-south-1\" -backend-config=\"encrypt=true\" -backend-config=\"dynamodb_table=terraform-state\""
  }
}
