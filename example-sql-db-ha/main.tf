module "private-service-access" {
  source          = "./modules/private_service_access"
  project_id      = var.project_id
  vpc_network     = module.network-safer-postgresql-simple.network_name
  vpc_network_url = module.network-safer-postgresql-simple.network_self_link
}

module "postgresql" {
  source  = "./modules/postgresql"
  name                 = var.pg_ha_name
  random_instance_name = true
  database_version     = var.database_version
  project_id           = var.project_id
  zone                 = "us-west1-a"
  region               = "us-west1"
  tier                 = "db-f1-micro"
  deletion_protection  = var.deletion_protection
  create_timeout       = "20m"
  ip_configuration     = local.ip_configuration
  backup_configuration = var.backup_configuration 
  read_replica_name_suffix = "-test"
  read_replicas = [
    {
      name             = "0"
      zone             = "us-west1-a"
      tier             = "db-f1-micro"
      ip_configuration = local.read_replica_ip_configuration
      database_flags   = var.replica_database_flags
      disk_autoresize  = null
      disk_size        = null
      disk_type        = var.disk_type
      user_labels      = var.user_labels
    },
    {
      name             = "1"
      zone             = "us-west1-b"
      tier             = "db-f1-micro"
      ip_configuration = local.read_replica_ip_configuration
      database_flags   = var.replica_database_flags
      disk_autoresize  = null
      disk_size        = null
      disk_type        = var.disk_type
      user_labels      = var.user_labels
    },
    {
      name             = "2"
      zone             = "us-west1-c"
      tier             = "db-f1-micro"
      ip_configuration = local.read_replica_ip_configuration
      database_flags   = var.replica_database_flags
      disk_autoresize  = null
      disk_size        = null
      disk_type        = var.disk_type
      user_labels      = var.user_labels
    },
  ]

  db_name      = var.pg_ha_name
  db_charset   = "UTF8"
  db_collation = "en_US.UTF8"

  additional_databases = var.additional_databases

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
  module_depends_on = [module.private-service-access.peering_completed]
}



// clone
// restore_backup_context
