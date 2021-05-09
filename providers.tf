terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.65.0"
    }
  }
  backend "gcs" {
    bucket  = "tf-gcs--backend"
  }
}

provider "google-beta" {
  alias   = "impersonating"
  region  = var.region
  project = var.project_id
  zone    = var.region
}

provider "google" {
  region  = var.region
  project = var.project_id
  zone    = var.region
  access_token = data.google_service_account_access_token.default.access_token
}

// provider "kubernetes" {
//   load_config_file       = false
//   host                   = "https://${module.gke.endpoint}"
//   token                  = data.google_client_config.default.access_token
//   cluster_ca_certificate = base64decode(module.gke.ca_certificate)
// }

// provider "null" {}