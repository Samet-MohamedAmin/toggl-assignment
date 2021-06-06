provider "google" {
  project = var.project
  region  = var.region
}

terraform {
  # This module is now only being tested with Terraform 0.14.x.
  required_version = ">= 0.14.0"

  required_providers {

    google = {
      source  = "registry.terraform.io/hashicorp/google"
      version = "~> 3.69.0"
    }

    google-beta = {
      source  = "registry.terraform.io/hashicorp/google-beta"
      version = "~> 3.69.0"
    }

    random = {
      source  = "registry.terraform.io/hashicorp/random"
      version = "~> 3.1.0"
    }

    null = {
      source  = "registry.terraform.io/hashicorp/null"
      version = "~> 3.1.0"
    }
  }
}
