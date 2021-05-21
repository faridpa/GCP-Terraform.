module "foundation" {
  source             = "./modules/foundation"
  billing_account_id = var.billing_account_id
  org_id             = var.org_id
  region             = var.region
  project_name       = var.project_name
  network_name       = var.network_name
  projects           = var.projects
  subnetwork_1_name  = var.subnetwork_1_name
  subnetwork_2_name  = var.subnetwork_2_name
  ip_range_pods      = var.ip_range_pods
  private_svc_ranges = var.private_svc_ranges
}