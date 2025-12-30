# GCP Provider Configuration
# Part 2: Setting Up Terraform
#
# This example validates GCP authentication by reading project information.
# Cost: $0.00 (only reads data, creates no resources)

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

# Provider configuration
provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region

  # Authentication happens automatically via:
  # 1. GOOGLE_APPLICATION_CREDENTIALS environment variable (service account JSON)
  # 2. Application Default Credentials (gcloud auth application-default login)
  # 3. GCE metadata server (if running on Google Compute Engine)
}

# Variables
variable "gcp_project_id" {
  description = "GCP Project ID"
  type        = string

  # You must provide this via:
  # 1. terraform.tfvars file
  # 2. -var="gcp_project_id=your-project" flag
  # 3. TF_VAR_gcp_project_id environment variable
}

variable "gcp_region" {
  description = "GCP region for resources"
  type        = string
  default     = "us-central1"
}

# Data source: Read current project information
data "google_project" "current" {
  project_id = var.gcp_project_id
}

# Data source: Read available GCP zones in current region
data "google_compute_zones" "available" {
  region = var.gcp_region
}

# Data source: Read billing account (if accessible)
data "google_billing_account" "account" {
  count = var.check_billing ? 1 : 0

  # This requires billing.accounts.get permission
  # May fail for some service accounts - set check_billing=false if needed
  display_name = ""
  open         = true
}

variable "check_billing" {
  description = "Whether to check billing account (requires permissions)"
  type        = bool
  default     = false
}

# Outputs: Display project information
output "project_id" {
  description = "GCP Project ID"
  value       = data.google_project.current.project_id
}

output "project_number" {
  description = "GCP Project Number"
  value       = data.google_project.current.number
}

output "project_name" {
  description = "GCP Project Name"
  value       = data.google_project.current.name
}

output "current_region" {
  description = "Current GCP region"
  value       = var.gcp_region
}

output "available_zones" {
  description = "Available zones in current region"
  value       = data.google_compute_zones.available.names
}

output "zones_count" {
  description = "Number of available zones"
  value       = length(data.google_compute_zones.available.names)
}

# Example output when you run `terraform apply`:
#
# project_id = "my-terraform-project"
# project_number = "123456789012"
# project_name = "My Terraform Project"
# current_region = "us-central1"
# available_zones = ["us-central1-a", "us-central1-b", "us-central1-c", "us-central1-f"]
# zones_count = 4
