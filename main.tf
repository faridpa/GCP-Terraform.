resource "random_id" "id" {
  byte_length = 4
  prefix      = var.project_name
}

resource "google_folder" "folder" {
  // provider     = google-beta
  display_name = var.folder_name
  parent       = "organizations/${var.org_id}"
}

resource "google_project" "project" {
  // provider        = google-beta
  name            = var.project_name
  project_id      = random_id.id.hex
  billing_account = var.billing_account
  folder_id       = google_folder.folder.name
}

resource "google_project_service" "service" {
  // provider = google-beta
  for_each = toset([
    "compute.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudbilling.googleapis.com",
    "iam.googleapis.com",
    "compute.googleapis.com",
    "serviceusage.googleapis.com"
  ])
  service = each.key
  project            = google_project.project.project_id
  disable_on_destroy = false
}

resource "google_service_account" "prj-service-account" {
  // provider     = google-beta
  account_id   = "${google_project.project.project_id}-sa"
  display_name = "Service Account for ${google_project.project.project_id} project"
  project      = google_project.project.project_id
  // depends_on   = [google_project_service.service]
}

resource "google_service_account_iam_binding" "impersination-iam" {
  // provider           = google-beta
  service_account_id = google_service_account.prj-service-account.name
  role               = "roles/iam.serviceAccountUser"
  members            = [
    "serviceAccount:${var.target_service_account}",
    "user:devops@integraldevops.com",
    "user:farid@integraldevops.com",
    "user:osman@integraldevops.com",
  ]
//   condition {
//     title       = "expires_after_2019_12_31"
//     description = "Expiring at midnight of 2019-12-31"
//     expression  = "request.time < timestamp(\"2020-01-01T00:00:00Z\")"
//   }
}

resource "google_service_account_iam_binding" "token-creator-iam" {
  // provider           = google-beta
  service_account_id = google_service_account.prj-service-account.name
  role               = "roles/iam.serviceAccountTokenCreator"
  members            = [
    "serviceAccount:${var.target_service_account}",
    "user:devops@integraldevops.com",
    "user:farid@integraldevops.com",
    "user:osman@integraldevops.com",
  ]
//   condition {
//     title       = "expires_after_2019_12_31"
//     description = "Expiring at midnight of 2019-12-31"
//     expression  = "request.time < timestamp(\"2020-01-01T00:00:00Z\")"
//   }
}

resource "google_project_iam_binding" "project" {
  // provider = google-beta
  project  = google_project.project.project_id
  role     = "roles/editor"
  members  = [
    "serviceAccount:${google_service_account.prj-service-account.email}",
  ]
//   condition {
//     title       = "expires_after_2019_12_31"
//     description = "Expiring at midnight of 2019-12-31"
//     expression  = "request.time < timestamp(\"2020-01-01T00:00:00Z\")"
//   }
}
