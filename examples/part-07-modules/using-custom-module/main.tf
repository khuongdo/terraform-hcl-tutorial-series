# Using Custom Module Example
# Part 7: Modules

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
}

# Use custom web-server module
module "dev_server" {
  source = "../modules/web-server"

  name_prefix   = "dev-web"
  instance_type = "t2.micro"

  allowed_ports = [80, 22]
  allowed_cidrs = ["0.0.0.0/0"]

  tags = {
    Environment = "development"
    ManagedBy   = "terraform"
    Module      = "web-server"
  }
}

module "prod_server" {
  source = "../modules/web-server"

  name_prefix   = "prod-web"
  instance_type = "t3.small"

  allowed_ports     = [80, 443]
  allowed_cidrs     = ["10.0.0.0/8"]
  enable_monitoring = true

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
    Module      = "web-server"
  }
}
