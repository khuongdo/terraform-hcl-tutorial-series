# GCP Multi-Cloud Example
# Part 8: Multi-Cloud

terraform {
  required_version = ">= 1.6.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  default = "us-central1"
}

variable "app_name" {
  default = "multi-cloud-demo"
}

# Cloud Storage Bucket (Object Storage)
resource "google_storage_bucket" "storage" {
  name     = "${var.project_id}-${var.app_name}"
  location = var.region

  labels = {
    name  = var.app_name
    cloud = "gcp"
  }
}

# Compute Engine Instance
resource "google_compute_instance" "compute" {
  name         = "${var.app_name}-compute"
  machine_type = "e2-micro"
  zone         = "${var.region}-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {} # Ephemeral public IP
  }

  labels = {
    name  = var.app_name
    cloud = "gcp"
  }
}

output "storage_endpoint" {
  value = "gs://${google_storage_bucket.storage.name}"
}

output "compute_ip" {
  value = google_compute_instance.compute.network_interface[0].access_config[0].nat_ip
}
