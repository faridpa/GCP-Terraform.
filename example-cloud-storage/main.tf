module "gcs_buckets" {
  source  = "terraform-google-modules/cloud-storage/google"
  version = "~> 1.7"
  project_id  = var.project_id
  names = ["one"]
  prefix = var.bucket_name
  location = "US"
  set_admin_roles = true
  versioning = {
    first = true
  }
}
