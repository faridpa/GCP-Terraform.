// #output who am authenticated as
// output "source-email" {
//   value = data.google_client_openid_userinfo.me.email
// }

// #output the service account I am impersonating
// output "target-email" {
//   value = data.google_client_openid_userinfo.thenewme.email
// }

// output "project_id" {
//   value = google_project.project.project_id
// }

// output "project_sa" {
//   value = google_service_account.prj-service-account.email
// }

// output "shared-vpc-subnets" {
//   value = module.shared-vpc-network.subnets
// }

// output "gke-endpoint" {
//   value = module.gke.endpoint
//   sensitive = true
// }

// output "shared-vpc-subnet-self-links" {
//   value = module.shared-vpc-network.subnets_self_links
// }

// output "folder-ids" {
//   value = lookup(lookup(module.folders.folders_map, "root"), "id")
// }

output "project_ids" {
  value = local.project_ids
}
