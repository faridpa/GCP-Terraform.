module "iap_bastion" {
  source       = "terraform-google-modules/bastion-host/google"
  project      = var.project_id
  zone         = var.zone
  host_project = var.project_id
  network      = var.network_self_link
  subnet       = var.subnetwork_self_link
  members      = var.members
}