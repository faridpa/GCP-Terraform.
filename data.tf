data "google_client_config" "default" {
  provider = google-beta.impersonating
}

data "google_client_openid_userinfo" "me" {
  provider = google-beta.impersonating
}

data "google_service_account_access_token" "default" {
  provider = google-beta.impersonating
  target_service_account = var.target_service_account
  scopes = ["userinfo-email", "cloud-platform"]
  lifetime = "3600s"
}

data "google_client_openid_userinfo" "thenewme" {
  // provider = google-beta
}

data "google_compute_zones" "available" {
  region = var.region
  status = "UP"
}
