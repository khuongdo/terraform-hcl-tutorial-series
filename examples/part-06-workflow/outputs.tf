# Outputs
# Part 6: Workflow

output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.example.id
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.example.arn
}

output "bucket_region" {
  description = "Region where bucket is created"
  value       = aws_s3_bucket.example.region
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table for state locking"
  value       = aws_dynamodb_table.terraform_locks.name
}

output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table"
  value       = aws_dynamodb_table.terraform_locks.arn
}

output "current_workspace" {
  description = "Current Terraform workspace"
  value       = terraform.workspace
}

output "common_tags" {
  description = "Common tags applied to resources"
  value       = local.common_tags
}
