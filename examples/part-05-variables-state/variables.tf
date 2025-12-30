# Input Variables
# Part 5: Variables, Outputs & State

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-west-2"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"

  validation {
    condition     = can(regex("^t[23]\\.(micro|small|medium|large)$", var.instance_type))
    error_message = "Instance type must be t2 or t3 family (micro, small, medium, large)."
  }
}

variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  default     = 1

  validation {
    condition     = var.instance_count >= 1 && var.instance_count <= 10
    error_message = "Instance count must be between 1 and 10."
  }
}

variable "enable_monitoring" {
  description = "Enable detailed CloudWatch monitoring"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags for resources"
  type        = map(string)
  default     = {}
}

variable "db_password" {
  description = "Database password (sensitive)"
  type        = string
  sensitive   = true # Masks value in output

  validation {
    condition     = length(var.db_password) >= 16
    error_message = "Database password must be at least 16 characters."
  }
}

variable "allowed_ssh_cidrs" {
  description = "CIDR blocks allowed for SSH access"
  type        = list(string)
  default     = []
}

variable "server_config" {
  description = "Server configuration object"
  type = object({
    instance_type = string
    volume_size   = number
    volume_type   = string
  })

  default = {
    instance_type = "t2.micro"
    volume_size   = 20
    volume_type   = "gp3"
  }
}
