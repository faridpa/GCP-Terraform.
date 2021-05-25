module "cloud-router" {
  source               = "./modules/cloud-router"
  project_id           = module.foundation.shared_vpc_project_id
  cloud_router_name    = var.cloud_router_name
  network_self_link    = module.foundation.shared_vpc_network_self_link
  region               = var.region
  nat_gateway_name     = var.nat_gateway_name
}
