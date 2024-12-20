# IAM Role for ECR Access
resource "aws_iam_role" "ecr_access_role" {
  name               = "eks-ecr-access-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect    = "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_access_policy" {
  role       = aws_iam_role.ecr_access_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# ECR Repository
resource "aws_ecr_repository" "my_repository" {
  name = "my-python-app"

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = true
  }

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    "Environment" = "production"
  }
}

output "ecr_repository_url" {
  description = "The URL of the created ECR repository"
  value       = aws_ecr_repository.my_repository.repository_url
}

output "ecr_access_role_arn" {
  value = aws_iam_role.ecr_access_role.arn
}
