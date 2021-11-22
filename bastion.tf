module "iap_bastion" {
  source               = "./modules/bastion"
  zone                 = var.zone
  project_id           = module.foundation.shared_vpc_project_id
  network_self_link    = module.foundation.shared_vpc_network_self_link
  subnetwork_self_link = module.foundation.shared_vpc_subnets_self_links[0]
  members              = var.members
  shielded_vm          = false
}
