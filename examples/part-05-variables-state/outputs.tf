# Output Definitions
# Part 5: Variables, Outputs & State

# Simple outputs
output "region" {
  description = "AWS region used"
  value       = var.aws_region
}

output "environment" {
  description = "Deployment environment"
  value       = var.environment
}

output "instance_count" {
  description = "Number of instances created"
  value       = var.instance_count
}

# Resource-based outputs
output "instance_ids" {
  description = "IDs of all created instances"
  value       = aws_instance.web[*].id
}

output "instance_public_ips" {
  description = "Public IP addresses of instances"
  value       = aws_instance.web[*].public_ip
}

output "instance_private_ips" {
  description = "Private IP addresses of instances"
  value       = aws_instance.web[*].private_ip
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.web.id
}

# Structured output
output "instance_details" {
  description = "Detailed information about all instances"
  value = [
    for instance in aws_instance.web : {
      id         = instance.id
      public_ip  = instance.public_ip
      private_ip = instance.private_ip
      az         = instance.availability_zone
      type       = instance.instance_type
    }
  ]
}

# Sensitive output (masked in console output)
output "db_connection_string" {
  description = "Database connection string (sensitive)"
  value       = local.db_connection_string
  sensitive   = true # Prevents display in terraform output
}

# Output with conditional logic
output "monitoring_status" {
  description = "CloudWatch monitoring status"
  value       = var.enable_monitoring ? "enabled" : "disabled"
}

# Output demonstrating map usage
output "instance_tags" {
  description = "Tags applied to instances"
  value       = var.tags
}
