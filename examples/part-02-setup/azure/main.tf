# Azure Provider Configuration
# Part 2: Setting Up Terraform
#
# This example validates Azure authentication by reading subscription information.
# Cost: $0.00 (only reads data, creates no resources)

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# Provider configuration
provider "azurerm" {
  features {}

  # Authentication happens automatically via:
  # 1. Azure CLI (az login)
  # 2. Service Principal (ARM_* environment variables)
  # 3. Managed Identity (if running on Azure compute)
}

# Data source: Read current Azure client configuration
# This validates authentication without creating resources
data "azurerm_client_config" "current" {}

# Data source: Read current subscription details
data "azurerm_subscription" "current" {}

# Data source: Read available Azure locations
data "azurerm_locations" "available" {}

# Outputs: Display subscription information
output "subscription_id" {
  description = "Azure Subscription ID"
  value       = data.azurerm_subscription.current.subscription_id
}

output "subscription_name" {
  description = "Azure Subscription Name"
  value       = data.azurerm_subscription.current.display_name
}

output "tenant_id" {
  description = "Azure Tenant ID"
  value       = data.azurerm_client_config.current.tenant_id
}

output "client_id" {
  description = "Azure Client ID (if using Service Principal)"
  value       = data.azurerm_client_config.current.client_id
}

output "available_locations" {
  description = "Available Azure locations"
  value       = data.azurerm_locations.available.names
}

output "locations_count" {
  description = "Number of available Azure locations"
  value       = length(data.azurerm_locations.available.names)
}

# Example output when you run `terraform apply`:
#
# subscription_id = "12345678-1234-1234-1234-123456789012"
# subscription_name = "My Azure Subscription"
# tenant_id = "87654321-4321-4321-4321-210987654321"
# client_id = "abcdef12-3456-7890-abcd-ef1234567890"
# available_locations = ["eastus", "eastus2", "westus", "westus2", ...]
# locations_count = 60
