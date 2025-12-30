# Variables and State Example
# Part 5: Variables, Outputs & State

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
      Environment = var.environment
      ManagedBy   = "terraform"
      Tutorial    = "part-05-variables-state"
    }
  }
}

# Find latest Amazon Linux AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Security group for instances
resource "aws_security_group" "web" {
  name        = "${var.environment}-web-sg"
  description = "Security group for web servers in ${var.environment}"

  # Allow SSH from specified CIDRs
  dynamic "ingress" {
    for_each = var.allowed_ssh_cidrs
    content {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
      description = "SSH access from ${ingress.value}"
    }
  }

  # Allow HTTP from anywhere (demo purposes)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access"
  }

  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-web-sg"
    }
  )
}

# Create EC2 instances
resource "aws_instance" "web" {
  count = var.instance_count

  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.server_config.instance_type

  vpc_security_group_ids = [aws_security_group.web.id]

  monitoring = var.enable_monitoring

  root_block_device {
    volume_size = var.server_config.volume_size
    volume_type = var.server_config.volume_type
    encrypted   = true # Always encrypt in production!
  }

  user_data = templatefile("${path.module}/user-data.sh", {
    environment = var.environment
    instance_id = count.index + 1
  })

  tags = merge(
    var.tags,
    {
      Name  = "${var.environment}-web-${count.index + 1}"
      Index = count.index + 1
    }
  )
}

# Simulated database connection string (demonstrates sensitive output)
# In real scenarios, this would come from AWS RDS or similar
locals {
  db_connection_string = "postgres://admin:${var.db_password}@localhost:5432/mydb"
}
