terraform {
  backend "s3" {
    bucket         = "test-terraform-state"
    key            = "global/s3/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "test-terraform-state"
  }
}