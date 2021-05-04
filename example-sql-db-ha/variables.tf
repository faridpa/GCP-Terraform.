variable "project_id" {}
variable "region" {}
variable "network_name" {}
variable "target_service_account" {}
variable "pg_ha_name" {}
variable "pg_ha_external_ip_range" {}
variable "database_version" {}
variable "availability_type" {}
variable "disk_type" {
  default = "PD_HDD"
}
variable "deletion_protection" {
  type = bool
  default = false
}
variable "additional_databases" {
  description = "A list of databases to be created in your cluster"
  type = list(object({
    name      = string
    charset   = string
    collation = string
  }))
  default = []
}
variable "user_labels" {
  type        = map(string)
  default     = {}
}
variable "database_flags" {
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}
variable "replica_database_flags" {
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}
// variable "ip_configuration" {
//   type = object({
//     authorized_networks = list(map(string))
//     ipv4_enabled        = bool
//     private_network     = string
//     require_ssl         = bool
//   })
// }
variable "backup_configuration" {
  description = "The backup_configuration settings subblock for the database setings"
  type = object({
    enabled                        = bool
    start_time                     = string
    location                       = string
    point_in_time_recovery_enabled = bool
    transaction_log_retention_days = number
    backup_retention_settings      = map(string)
  })
}
