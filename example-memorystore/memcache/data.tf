data "google_client_config" "default" {
  provider = google.impersonating
}

data "google_client_openid_userinfo" "me" { 
  provider = google.impersonating
}

data "google_service_account_access_token" "default" {
  provider = google.impersonating
  target_service_account = var.target_service_account
  scopes = ["userinfo-email", "cloud-platform"]
  lifetime = "3000s"
}

data "google_client_openid_userinfo" "thenewme" {
}
