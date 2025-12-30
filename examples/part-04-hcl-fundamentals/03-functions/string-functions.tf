# String Functions
# Part 4: HCL Fundamentals

terraform {
  required_version = ">= 1.6.0"
}

variable "project_name" {
  description = "Project name for string manipulation"
  type        = string
  default     = "my-terraform-project"
}

variable "tags_list" {
  description = "List of tags to join"
  type        = list(string)
  default     = ["web", "api", "database"]
}

locals {
  # String interpolation
  resource_name = "${var.project_name}-server"

  # format() - Formatted strings
  formatted_name = format("%s-%03d", var.project_name, 42)

  # upper() / lower() - Case conversion
  uppercase_project = upper(var.project_name)
  lowercase_project = lower(var.project_name)

  # join() - Combine list into string
  joined_tags = join(", ", var.tags_list)
  path_joined = join("/", ["var", "log", "app"])

  # split() - Split string into list
  name_parts = split("-", var.project_name)

  # replace() - String replacement
  sanitized_name = replace(var.project_name, "-", "_")

  # substr() - Substring extraction
  short_name = substr(var.project_name, 0, 10)

  # trim() / trimspace() - Remove whitespace
  trimmed = trim("  terraform  ", " ")

  # regex() - Pattern matching
  extracted_number = regex("[0-9]+", "project-123-server")

  # String templates
  user_data = <<-EOT
    #!/bin/bash
    PROJECT=${var.project_name}
    TAGS=${join(",", var.tags_list)}
    echo "Initializing $PROJECT with tags: $TAGS"
  EOT
}

output "string_function_examples" {
  description = "Demonstrate string functions"
  value = {
    original           = var.project_name
    interpolated       = local.resource_name
    formatted          = local.formatted_name
    uppercase          = local.uppercase_project
    lowercase          = local.lowercase_project
    joined_tags        = local.joined_tags
    path_joined        = local.path_joined
    split_result       = local.name_parts
    replaced           = local.sanitized_name
    substring          = local.short_name
    trimmed            = local.trimmed
    regex_extracted    = local.extracted_number
    user_data_template = local.user_data
  }
}
