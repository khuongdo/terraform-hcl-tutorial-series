# HCL Type System Examples
# Part 4: HCL Fundamentals

terraform {
  required_version = ">= 1.6.0"
}

# Primitive Types

variable "instance_name" {
  description = "String type example"
  type        = string
  default     = "web-server"
}

variable "instance_count" {
  description = "Number type example"
  type        = number
  default     = 2
}

variable "enable_monitoring" {
  description = "Boolean type example"
  type        = bool
  default     = true
}

# Complex Types

variable "availability_zones" {
  description = "List type example"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "instance_tags" {
  description = "Map type example"
  type        = map(string)
  default = {
    Environment = "development"
    Team        = "platform"
    CostCenter  = "engineering"
  }
}

variable "server_config" {
  description = "Object type example (structured data)"
  type = object({
    instance_type = string
    ami_id        = string
    root_volume = object({
      size = number
      type = string
    })
  })

  default = {
    instance_type = "t2.micro"
    ami_id        = "ami-0c55b159cbfafe1f0"
    root_volume = {
      size = 20
      type = "gp3"
    }
  }
}

variable "subnet_cidrs" {
  description = "Tuple type example (fixed-length, mixed types)"
  type        = tuple([string, string, number])
  default     = ["10.0.1.0/24", "us-west-2a", 1]
}

# Type Constraints with Validation

variable "environment" {
  description = "Deployment environment with validation"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "port_number" {
  description = "Port number with range validation"
  type        = number
  default     = 8080

  validation {
    condition     = var.port_number > 0 && var.port_number < 65536
    error_message = "Port number must be between 1 and 65535."
  }
}

# Outputs demonstrating type usage

output "type_examples" {
  description = "Demonstrate various HCL types"
  value = {
    string_example  = var.instance_name
    number_example  = var.instance_count
    bool_example    = var.enable_monitoring
    list_example    = var.availability_zones
    map_example     = var.instance_tags
    object_example  = var.server_config
    tuple_example   = var.subnet_cidrs
  }
}

output "validation_examples" {
  description = "Variables with validation rules"
  value = {
    environment = var.environment
    port_number = var.port_number
  }
}
