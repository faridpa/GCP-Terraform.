module "redis" {
  source             = "./modules/redis"
  name               = var.redis_name
  project_id         = lookup(module.foundation.project_ids,"db-project")
  memory_size_gb     = var.memory_size_gb
  enable_apis        = var.enable_apis
  cpu_count          = var.cpu_count
  # network_self_link  = module.foundation.shared_vpc_network_self_link
  network_name       = module.foundation.shared_vpc_network_name
  network_project_id = module.foundation.shared_vpc_project_id
}