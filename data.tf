data "google_client_config" "default" {
  provider = google-beta
}

data "google_client_openid_userinfo" "me" {}

data "google_service_account_access_token" "default" {
 provider = google-beta
 target_service_account = var.target_service_account
 scopes = ["userinfo-email", "cloud-platform"]
 lifetime = "300s"
}

data "google_client_openid_userinfo" "thenewme" {
  provider = google-beta.impersonated
}
