variable "billing_account_id" {}
variable "org_id" {}
variable "region" {}
variable "zone" {}
variable "target_service_account" {}
variable "folder_name" {}
variable "project_name" {}
variable "project_id" {}
variable "network_name" {}
variable "cluster_name" {}
variable "ip_range_pods" {}
variable "ip_range_services" {}
variable "default_max_pods_per_node" {}
// variable "gke_project_name" {}
variable "projects" {
  type = list(string)
}

// variable "subnetwork" {}
variable "redis_name" {}
variable "memcache_name" {}
variable "memory_size_mb" {}
variable "enable_apis" {}
variable "cpu_count" {}
variable "memory_size_gb" {}
variable "pg_ha_name" {}
variable "pg_ha_external_ip_range" {}
variable "subnetwork_1_name" {}
variable "subnetwork_2_name" {}
variable "db_tier" {}
variable "private_svc_ranges" {}
variable "members" {
  type = list(string)
}
variable "cloud_router_name" {}
variable "nat_gateway_name" {}