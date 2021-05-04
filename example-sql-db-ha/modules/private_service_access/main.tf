// We define a VPC peering subnet that will be peered with the
// Cloud SQL instance network. The Cloud SQL instance will
// have a private IP within the provided range.
// https://cloud.google.com/vpc/docs/configure-private-services-access
resource "google_compute_global_address" "google-managed-services-range" {
  provider      = google-beta
  project       = var.project_id
  name          = "google-managed-services-${var.vpc_network}"
  purpose       = "VPC_PEERING"
  address       = var.address
  prefix_length = var.prefix_length
  ip_version    = var.ip_version
  labels        = var.labels
  address_type  = "INTERNAL"
  network       = var.vpc_network_url
}

# Creates the peering with the producer network.
resource "google_service_networking_connection" "private_service_access" {
  provider                = google-beta
  network                 = var.vpc_network_url
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.google-managed-services-range.name]
}

resource "null_resource" "dependency_setter" {
  depends_on = [google_service_networking_connection.private_service_access]
}
