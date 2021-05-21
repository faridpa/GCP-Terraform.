module "private-service-access" {
  source            = "../private-service-access"
  name              = var.pg_ha_name
  project_id        = var.network_project_id
  vpc_network       = var.network_name
  network_self_link = var.network_self_link
}

module "postgresql" {
  source                 = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
  name                   = var.pg_ha_name
  random_instance_name   = true
  database_version       = "POSTGRES_13"
  project_id             = can(module.private-service-access.peering_completed) ? var.project_id : ""
  zone                   = var.zone
  region                 = var.region
  tier                   = var.db_tier
  deletion_protection    = false
  create_timeout         = "20m"
  ip_configuration       = {
    ipv4_enabled        = false
    require_ssl         = false
    private_network     = "projects/${var.network_project_id}/global/networks/${var.network_name}"
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
      tier             = var.db_tier
      ip_configuration = {
        ipv4_enabled         = false
        require_ssl          = false
        private_network      = "projects/${var.network_project_id}/global/networks/${var.network_name}"
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