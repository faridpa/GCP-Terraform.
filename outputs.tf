#output who am authenticated as
output "source-email" {
  value = data.google_client_openid_userinfo.me.email
}

#output the service account I am impersonating
output "target-email" {
  value = data.google_client_openid_userinfo.thenewme.email
}

output "project_id" {
  value = google_project.project.project_id
}

output "project_sa" {
  value = google_service_account.prj-service-account.email
}
