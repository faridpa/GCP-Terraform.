module "postgresql" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
  name                 = var.db_name
  random_instance_name = true
  database_version     = "POSTGRES_9_6"
  project_id           = var.project_id
  zone                 = "us-west1-a"
  region               = "us-west1"
  tier                 = "db-f1-micro"
  deletion_protection  = false
  create_timeout       = "20m"
}
