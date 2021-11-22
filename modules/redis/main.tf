# module "private-service-access" {
#   source            = "../private-service-access"
#   name              = var.name
#   project_id        = var.network_project_id
#   vpc_network       = var.network_name
#   network_self_link = var.network_self_link
# }

module "redis" {
  source             = "terraform-google-modules/memorystore/google"
  name               = var.name
  connect_mode       = "PRIVATE_SERVICE_ACCESS"
  # project            = can(module.private-service-access.peering_completed) ? var.project_id : ""
  project            = var.project_id
  memory_size_gb     = var.memory_size_gb
  enable_apis        = var.enable_apis
  authorized_network = "projects/${var.network_project_id}/global/networks/${var.network_name}"
}