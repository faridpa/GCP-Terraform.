resource "google_compute_global_address" "google-managed-services-shared-vpc" {
  provider      = google-beta
  count         = var.private_svc_ranges
  project       = var.project_id
  name          = "google-managed-services-${var.vpc_network}-${count.index}"
  purpose       = "VPC_PEERING"
  # address       = var.address
  prefix_length = var.prefix_length
  ip_version    = var.ip_version
  labels        = var.labels
  address_type  = "INTERNAL"
  network       = var.network_self_link
  }

# Creates the peering with the producer network.
resource "google_service_networking_connection" "private_service_access" {
  provider                = google-beta
  network                 = var.network_self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = google_compute_global_address.google-managed-services-shared-vpc[*].name
}
resource "null_resource" "dependency_setter" {
  depends_on = [google_service_networking_connection.private_service_access]
}
