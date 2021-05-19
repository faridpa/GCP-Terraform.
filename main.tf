module "foundation" {
  source  = "./modules/foundation"
  billing_account_id = var.billing_account_id
  org_id             = var.org_id
  region             = var.region
  project_name       = var.project_name
  network_name       = var.network_name
  projects           = var.projects
}

# module "gke" {
#   source  = "./modules/gke"
#   project_id                 = var.project_id
#   network_project_id         = var.network_project_id
#   name                       = var.cluster_name
#   region                     = var.region
#   zones                      = data.google_compute_zones.available.names
#   network                    = var.network_name
#   subnetwork                 = var.subnetwork
#   ip_range_pods              = var.ip_range_pods
#   ip_range_services          = var.ip_range_services 
#   default_max_pods_per_node  = var.default_max_pods_per_node
# }