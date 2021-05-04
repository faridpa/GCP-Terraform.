region = "us-west1"
project_id = "projectabcc79e26c4"
network_name = "service-vpc-01"
target_service_account = "projectabcc79e26c4-sa@projectabcc79e26c4.iam.gserviceaccount.com"
pg_ha_name = "myhapostgres"
pg_ha_external_ip_range = "0.0.0.0/0"
availability_type = "REGIONAL"
database_version = "POSTGRES_13"
disk_type = "PD_HDD"
additional_databases = [
  {
    name      = "testdb"
    charset   = "UTF8"
    collation = "en_US.UTF8"
  },
]
user_labels = {
  managed-by = "terraform",
  business   = "my_co"
}
database_flags = [
    { name = "autovacuum", value = "on" },
    { name = "cloudsql.enable_iam_login", value = "on" },
    { name = "cloudsql.iam_authentication", value = "on" },
    { name = "cloudsql.enable_pgaudit", value = "off" },
]
replica_database_flags = [
    { name = "autovacuum", value = "on" },
]
backup_configuration = {
    enabled                        = true
    start_time                     = "21:00"
    location                       = null
    point_in_time_recovery_enabled = false
    transaction_log_retention_days = 1
    backup_retention_settings      = {
      retained_backups = 1
      retention_unit   = "COUNT"
    }
  }
