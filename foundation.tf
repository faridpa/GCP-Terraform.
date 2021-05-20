module "foundation" {
  source             = "./modules/foundation"
  billing_account_id = var.billing_account_id
  org_id             = var.org_id
  region             = var.region
  project_name       = var.project_name
  network_name       = var.network_name
  projects           = var.projects
}
