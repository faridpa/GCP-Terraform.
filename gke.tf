module "gke" {
  source                     = "./modules/gke"
  project_id                 = lookup(module.foundation.project_ids,"gke-project")
  network_project_id         = module.foundation.shared_vpc_project_id
  cluster_name               = var.cluster_name
  region                     = var.region
  network_name               = module.foundation.shared_vpc_network_name
  subnetwork                 = var.subnetwork_1_name
  ip_range_pods              = var.ip_range_pods
  ip_range_services          = var.ip_range_services
  default_max_pods_per_node  = var.default_max_pods_per_node
}
