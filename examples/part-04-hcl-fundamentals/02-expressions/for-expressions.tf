# For Expressions and Splat Operators
# Part 4: HCL Fundamentals

terraform {
  required_version = ">= 1.6.0"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "instances" {
  description = "Map of instances"
  type = map(object({
    instance_type = string
    environment   = string
  }))
  default = {
    web1 = { instance_type = "t2.micro", environment = "prod" }
    web2 = { instance_type = "t2.small", environment = "prod" }
    db1  = { instance_type = "t3.large", environment = "prod" }
    test = { instance_type = "t2.micro", environment = "dev" }
  }
}

locals {
  # For expression: Transform list
  uppercase_azs = [for az in var.availability_zones : upper(az)]

  # For expression: Transform with index
  az_with_index = [for i, az in var.availability_zones : "${i+1}: ${az}"]

  # For expression: Filter list
  prod_instances = [for k, v in var.instances : k if v.environment == "prod"]

  # For expression: Transform map to list
  instance_types = [for k, v in var.instances : v.instance_type]

  # For expression: Transform map to map
  instance_envs = {for k, v in var.instances : k => v.environment}

  # For expression: Conditional value
  instance_tags = {for k, v in var.instances : k => {
    Name = k
    Size = v.environment == "prod" ? "large" : "small"
  }}
}

output "for_expression_examples" {
  description = "Demonstrate for expressions"
  value = {
    original_azs       = var.availability_zones
    uppercase_azs      = local.uppercase_azs
    az_with_index      = local.az_with_index
    prod_instances     = local.prod_instances
    all_instance_types = local.instance_types
    instance_envs      = local.instance_envs
    instance_tags      = local.instance_tags
  }
}
