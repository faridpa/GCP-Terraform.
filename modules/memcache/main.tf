# module "private-service-access" {
#   source            = "../private-service-access"
#   name              = var.name
#   project_id        = var.network_project_id
#   vpc_network       = var.network_name
#   network_self_link = var.network_self_link
# }

module "memcache" {
  source             = "terraform-google-modules/memorystore/google//modules/memcache"
  name               = var.name
  # project            = can(module.private-service-access.peering_completed) ? var.project_id : ""
  project            = var.project_id
  memory_size_mb     = var.memory_size_mb
  enable_apis        = var.enable_apis
  cpu_count          = var.cpu_count
  region             = var.region
  authorized_network = "projects/${var.network_project_id}/global/networks/${var.network_name}"
}