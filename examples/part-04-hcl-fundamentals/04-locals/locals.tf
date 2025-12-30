# Local Values for DRY Patterns
# Part 4: HCL Fundamentals

terraform {
  required_version = ">= 1.6.0"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "myapp"
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

# Local values - computed once, reused many times
locals {
  # Common resource naming pattern
  resource_prefix = "${var.project_name}-${var.environment}"

  # Common tags for all resources
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Region      = var.region
  }

  # Computed configuration based on environment
  config = {
    instance_type = var.environment == "prod" ? "t3.large" : "t2.micro"
    instance_count = var.environment == "prod" ? 10 : 2
    enable_backup = var.environment == "prod" ? true : false
    retention_days = var.environment == "prod" ? 90 : 7
  }

  # Resource names using prefix
  ec2_instance_name = "${local.resource_prefix}-web"
  rds_instance_name = "${local.resource_prefix}-db"
  s3_bucket_name = "${local.resource_prefix}-data-${var.region}"

  # Complex computed values
  availability_zones = [
    "${var.region}a",
    "${var.region}b",
    "${var.region}c"
  ]

  # CIDR blocks for VPC subnets
  vpc_cidr = "10.0.0.0/16"
  subnet_cidrs = [
    cidrsubnet(local.vpc_cidr, 8, 0),  # 10.0.0.0/24
    cidrsubnet(local.vpc_cidr, 8, 1),  # 10.0.1.0/24
    cidrsubnet(local.vpc_cidr, 8, 2),  # 10.0.2.0/24
  ]

  # Security group rules as structured data
  ingress_rules = {
    http = {
      port        = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    https = {
      port        = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    ssh = {
      port        = 22
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/8"]  # Internal only
    }
  }

  # Merge environment-specific tags
  all_tags = merge(
    local.common_tags,
    var.environment == "prod" ? {
      Backup      = "daily"
      Compliance  = "required"
      CostCenter  = "production"
    } : {
      Backup      = "none"
      CostCenter  = "development"
    }
  )
}

# Outputs showing local values in action
output "local_examples" {
  description = "Demonstrate local values for DRY code"
  value = {
    # Resource naming
    resource_prefix   = local.resource_prefix
    ec2_instance_name = local.ec2_instance_name
    rds_instance_name = local.rds_instance_name
    s3_bucket_name    = local.s3_bucket_name

    # Configuration
    config = local.config

    # Tags
    common_tags = local.common_tags
    all_tags    = local.all_tags

    # Network configuration
    vpc_cidr           = local.vpc_cidr
    subnet_cidrs       = local.subnet_cidrs
    availability_zones = local.availability_zones

    # Security rules
    ingress_rules = local.ingress_rules
  }
}

# Example: How you would use locals in resources
# (Not creating real resources, just showing pattern)
output "resource_usage_example" {
  description = "How to reference locals in resources"
  value = <<-EOT
    # Example resource using locals:

    resource "aws_instance" "web" {
      instance_type = local.config.instance_type
      count         = local.config.instance_count

      tags = merge(
        local.all_tags,
        { Name = local.ec2_instance_name }
      )
    }

    resource "aws_s3_bucket" "data" {
      bucket = local.s3_bucket_name
      tags   = local.all_tags
    }
  EOT
}
