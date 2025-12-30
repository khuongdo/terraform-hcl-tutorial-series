# Terraform Workflow Example
# Part 6: Core Workflow

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Tutorial    = "part-06-workflow"
      Environment = terraform.workspace
      ManagedBy   = "terraform"
    }
  }
}

# Variables
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "bucket_prefix" {
  description = "S3 bucket name prefix"
  type        = string
  default     = "terraform-workflow-demo"
}

# Random suffix to ensure unique bucket name
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# S3 bucket for demonstration
resource "aws_s3_bucket" "example" {
  bucket = "${var.bucket_prefix}-${terraform.workspace}-${random_id.bucket_suffix.hex}"

  tags = {
    Name        = "Terraform Workflow Demo"
    Workspace   = terraform.workspace
    Description = "Demonstrates Terraform CLI workflow"
  }
}

# Enable versioning
resource "aws_s3_bucket_versioning" "example" {
  bucket = aws_s3_bucket.example.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.example.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.example.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# DynamoDB table for state locking demonstration
# (Will be used in Part 9 for remote state)
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks-${terraform.workspace}"
  billing_mode = "PAY_PER_REQUEST" # No cost when not in use
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "Terraform State Locks"
    Workspace   = terraform.workspace
    Description = "DynamoDB table for state locking"
  }
}

# Local values for demonstration
locals {
  common_tags = {
    Project     = "terraform-tutorial"
    ManagedBy   = "terraform"
    Environment = terraform.workspace
  }

  bucket_arn = aws_s3_bucket.example.arn
}
