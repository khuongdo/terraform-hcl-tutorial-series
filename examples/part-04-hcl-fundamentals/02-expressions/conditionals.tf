# Conditional Expressions
# Part 4: HCL Fundamentals

terraform {
  required_version = ">= 1.6.0"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

# Ternary Operator: condition ? true_val : false_val

locals {
  # Instance type based on environment
  instance_type = var.environment == "prod" ? "t3.large" : "t2.micro"

  # Instance count based on environment
  instance_count = var.environment == "prod" ? 10 : 2

  # Enable monitoring only in production
  enable_detailed_monitoring = var.environment == "prod" ? true : false

  # Complex conditional logic (nested ternary)
  log_retention_days = (
    var.environment == "prod" ? 90 :
    var.environment == "staging" ? 30 :
    7  # dev default
  )

  # Conditional with boolean operators
  requires_approval = var.environment == "prod" && local.enable_detailed_monitoring

  # Conditional resource count (0 or 1)
  create_backup = var.environment == "prod" ? 1 : 0
}

output "conditional_examples" {
  description = "Demonstrate conditional expressions"
  value = {
    environment                = var.environment
    instance_type              = local.instance_type
    instance_count             = local.instance_count
    monitoring_enabled         = local.enable_detailed_monitoring
    log_retention              = local.log_retention_days
    requires_manual_approval   = local.requires_approval
    backup_resource_count      = local.create_backup
  }
}
