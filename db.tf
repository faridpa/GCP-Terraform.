module "postgresql" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
  name                   = var.pg_ha_name
  random_instance_name   = true
  database_version       = "POSTGRES_13"
  project_id             = lookup(local.project_ids,"db-project")
  zone                   = "us-west1-a"
  region                 = "us-west1"
  tier                   = "db-f1-micro"
  deletion_protection    = false
  create_timeout         = "20m"
   ip_configuration       = {
   ipv4_enabled          = true
   require_ssl           = false
   private_network       = null
   authorized_networks   = [
     {
       name  = "${var.project_id}-cidr"
       value = var.pg_ha_external_ip_range
     },
   ]
 }
 backup_configuration = {
   enabled                        = true
   start_time                     = "21:00"
   location                       = null
   point_in_time_recovery_enabled = false
 }
 read_replica_name_suffix = "-test"
 read_replicas = [
   {
     name             = "0"
     zone             = "us-west1-a"
     tier             = "db-f1-micro"
     ip_configuration = local.read_replica_ip_configuration
     database_flags   = [{ name = "autovacuum", value = "off" }]
     disk_autoresize  = null
     disk_size        = null
     disk_type        = "PD_HDD"
     user_labels      = { bar = "baz" }
   },
   {
     name             = "1"
     zone             = "us-west1-b"
     tier             = "db-f1-micro"
     ip_configuration = local.read_replica_ip_configuration
     database_flags   = [{ name = "autovacuum", value = "off" }]
     disk_autoresize  = null
     disk_size        = null
     disk_type        = "PD_HDD"
     user_labels      = { bar = "baz" }
   },
   {
     name             = "2"
     zone             = "us-west1-c"
     tier             = "db-f1-micro"
     ip_configuration = local.read_replica_ip_configuration
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

module "private-service-access" {
  source            = "./modules/private-service-access"
  provider          = "google-beta"
  project_id        = module.vpc-network.project_id
  vpc_network       = module.vpc-network.network_name
  network_self_link = module.vpc-network.network_self_link
}

module "memcache" {
  source         = "terraform-google-modules/memorystore/google//modules/memcache"
  name           = var.name
  project        = can(module.private-service-access.peering_completed) ? lookup(local.project_ids,"db-project") : ""
  memory_size_mb = var.memory_size_mb
  enable_apis    = var.enable_apis
  cpu_count      = var.cpu_count
  region         = var.region
}

module "memorystore" {
  source             = "terraform-google-modules/memorystore/google"
  name               = var.name_redis
  connect_mode       = "PRIVATE_SERVICE_ACCESS"
  project            = can(module.private-service-access.peering_completed) ? lookup(local.project_ids,"db-project") : ""
  memory_size_gb     = var.memory_size_gb
  enable_apis        = var.enable_apis
  authorized_network = module.vpc-network.network_self_link
}