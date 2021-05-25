module "cloud_router" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 0.4"
  project = var.project_id
  name    = var.cloud_router_name
  network = var.network_self_link
  region  = var.region

  nats = [{
    name = var.nat_gateway_name
  }]
}