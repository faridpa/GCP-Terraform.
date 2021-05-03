terraform {
  required_providers {
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
      version = "0.9.0"
    }
  }
  backend "local" {}
}

provider "mongodbatlas" {
  public_key  = var.mongodb_atlas_api_pub_key
  private_key = var.mongodb_atlas_api_pri_key
}