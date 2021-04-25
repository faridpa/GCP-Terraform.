data "google_client_config" "default" {
  provider = google
}

data "google_client_openid_userinfo" "me" { }

data "google_service_account_access_token" "default" {
 provider = google
 target_service_account = var.target_service_account
 scopes = ["userinfo-email", "cloud-platform"]
 lifetime = "300s"
}

data "google_client_openid_userinfo" "thenewme" {
  provider = google.impersonated
}
