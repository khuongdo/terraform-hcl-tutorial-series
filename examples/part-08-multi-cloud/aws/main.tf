# AWS Multi-Cloud Example
# Part 8: Multi-Cloud

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
  region = var.region
}

variable "region" {
  default = "us-west-2"
}

variable "app_name" {
  default = "multi-cloud-demo"
}

# S3 Bucket (Object Storage)
resource "aws_s3_bucket" "storage" {
  bucket_prefix = "${var.app_name}-"

  tags = {
    Name  = "${var.app_name}-storage"
    Cloud = "AWS"
  }
}

# EC2 Instance (Compute)
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_instance" "compute" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"

  tags = {
    Name  = "${var.app_name}-compute"
    Cloud = "AWS"
  }
}

output "storage_endpoint" {
  value = "s3://${aws_s3_bucket.storage.id}"
}

output "compute_ip" {
  value = aws_instance.compute.public_ip
}
