# Your First Cloud Resource - EC2 Instance
# Part 3: Deploying Real Infrastructure

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
  region = "us-west-2"

  default_tags {
    tags = {
      Tutorial    = "terraform-hcl-part-03"
      Environment = "learning"
      ManagedBy   = "terraform"
    }
  }
}

# Find latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Create a simple EC2 instance
resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = "t2.micro"  # Free tier eligible

  tags = {
    Name = "my-first-terraform-instance"
  }
}
