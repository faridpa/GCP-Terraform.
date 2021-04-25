terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.65.0"
    }
  }
  backend "gcs" {
    bucket  = "tf-gcs--backend"
    prefix  = "terraform/state"
  }
}

provider "google" {
  region  = var.region
  project = var.project_id
  zone    = var.region
  // alias = "google-beta"
}

provider "google" {
  region  = var.region
  project = var.project_id
  zone    = var.region
  alias = "impersonated"
  access_token = data.google_service_account_access_token.default.access_token
}
