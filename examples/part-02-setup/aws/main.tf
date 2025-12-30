# AWS Provider Configuration
# Part 2: Setting Up Terraform
#
# This example validates AWS authentication by reading account information.
# Cost: $0.00 (only reads data, creates no resources)

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Provider configuration
provider "aws" {
  region = var.aws_region

  # Authentication happens automatically via:
  # 1. Environment variables (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)
  # 2. AWS CLI profile (~/.aws/credentials)
  # 3. IAM role (if running on EC2, ECS, Lambda)

  # Default tags applied to all resources
  # (not creating resources in this example, but good practice)
  default_tags {
    tags = {
      Environment = "learning"
      ManagedBy   = "terraform"
      Tutorial    = "terraform-hcl-part-02"
    }
  }
}

# Variable for AWS region
variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-west-2"
}

# Data source: Read current AWS account information
# This validates authentication without creating resources
data "aws_caller_identity" "current" {}

# Data source: Read available AWS regions
data "aws_regions" "available" {}

# Data source: Read current region details
data "aws_region" "current" {}

# Outputs: Display account information
output "account_id" {
  description = "AWS Account ID"
  value       = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  description = "ARN of authenticated identity"
  value       = data.aws_caller_identity.current.arn
}

output "caller_user" {
  description = "IAM user ID"
  value       = data.aws_caller_identity.current.user_id
}

output "current_region" {
  description = "Current AWS region"
  value       = data.aws_region.current.name
}

output "region_endpoint" {
  description = "AWS API endpoint for current region"
  value       = data.aws_region.current.endpoint
}

output "available_regions_count" {
  description = "Number of available AWS regions"
  value       = length(data.aws_regions.available.names)
}

# Example output when you run `terraform apply`:
#
# account_id = "123456789012"
# caller_arn = "arn:aws:iam::123456789012:user/terraform-user"
# caller_user = "AIDACKCEVSQ6C2EXAMPLE"
# current_region = "us-west-2"
# region_endpoint = "ec2.us-west-2.amazonaws.com"
# available_regions_count = 28
