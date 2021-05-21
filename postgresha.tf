module "postgresha" {
  source                     = "./modules/postgresha"
  project_id                 = lookup(module.foundation.project_ids,"db-project")
  network_project_id         = module.foundation.shared_vpc_project_id
  region                     = var.region
  network_name               = module.foundation.shared_vpc_network_name
  zone                       = var.zone
  pg_ha_name                 = var.pg_ha_name
  # network_self_link          = module.foundation.shared_vpc_network_self_link
  db_tier                    = var.db_tier
}