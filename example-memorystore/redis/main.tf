module "memorystore" {
  source         = "terraform-google-modules/memorystore/google"
  name           = var.name_redis
  project        = var.project
  memory_size_gb = var.memory_size_gb
  enable_apis    = var.enable_apis
}