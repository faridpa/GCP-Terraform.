module "private-service-access" {
  source      = "GoogleCloudPlatform/sql-db/google//modules/private_service_access"
  version     = "~> 4.5"
  project_id  = var.project
  vpc_network = "default"
}

module "memcache" {
  source         = "terraform-google-modules/memorystore/google//modules/memcache"
  name           = var.name
  project        = can(module.private-service-access.peering_completed) ? var.project : ""
  memory_size_mb = var.memory_size_mb
  enable_apis    = var.enable_apis
  cpu_count      = var.cpu_count
  region         = var.region
}
