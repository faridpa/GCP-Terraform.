module "postgresql" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
  name                   = var.pg_ha_name
  random_instance_name   = true
  database_version       = "POSTGRES_13"
  project_id             = can(module.private-service-access.peering_completed) ? lookup(local.project_ids,"db-project") : ""
  zone                   = var.zone
  region                 = var.region
  tier                   = "db-g1-small"
  deletion_protection    = false
  create_timeout         = "20m"
  ip_configuration       = {
    ipv4_enabled        = false
    require_ssl         = false
    private_network     = "projects/${module.shared-vpc-network.project_id}/global/networks/${module.shared-vpc-network.network_name}"
    authorized_networks = []
    //    {
    //      name  = "${var.project_id}-cidr"
    //      value = var.pg_ha_external_ip_range
    //    },
    // ]
  }
  backup_configuration = {
    enabled                        = true
    start_time                     = "21:00"
    location                       = null
    point_in_time_recovery_enabled = false
  }
  // read_replica_name_suffix = "-test"
  read_replicas = [
    {
      name             = "${var.pg_ha_name}-replica-0"
      zone             = var.zone
      tier             = "db-g1-small"
      ip_configuration = {
        ipv4_enabled         = false
        require_ssl          = false
        private_network      = "projects/${module.shared-vpc-network.project_id}/global/networks/${module.shared-vpc-network.network_name}"
        authorized_networks  = []
      }
      database_flags   = [{ name = "autovacuum", value = "off" }]
      disk_autoresize  = null
      disk_size        = null
      disk_type        = "PD_HDD"
      user_labels      = { bar = "baz" }
    },
  ]

  db_name      = var.pg_ha_name
  db_charset   = "UTF8"
  db_collation = "en_US.UTF8"

  additional_databases = [
    {
      name      = "${var.pg_ha_name}-additional"
      charset   = "UTF8"
      collation = "en_US.UTF8"
    },
  ]

  user_name     = "tftest"
  user_password = "foobar"

  additional_users = [
    {
      name     = "tftest2"
      password = "abcdefg"
      host     = "localhost"
    },
    {
      name     = "tftest3"
      password = "abcdefg"
      host     = "localhost"
    },
  ]
}

module "memcache" {
  source         = "terraform-google-modules/memorystore/google//modules/memcache"
  name           = var.name
  project        = can(module.private-service-access.peering_completed) ? lookup(local.project_ids,"db-project") : ""
  memory_size_mb = var.memory_size_mb
  enable_apis    = var.enable_apis
  cpu_count      = var.cpu_count
  region         = var.region
  authorized_network = "projects/${module.shared-vpc-network.project_id}/global/networks/${module.shared-vpc-network.network_name}"
}

module "memorystore" {
  source             = "terraform-google-modules/memorystore/google"
  name               = var.name_redis
  connect_mode       = "PRIVATE_SERVICE_ACCESS"
  project            = can(module.private-service-access.peering_completed) ? lookup(local.project_ids,"db-project") : ""
  memory_size_gb     = var.memory_size_gb
  enable_apis        = var.enable_apis
  authorized_network = module.shared-vpc-network.network_self_link
}
