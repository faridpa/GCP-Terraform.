module "memorystore" {
  source         = "terraform-google-modules/memorystore/google"
  name           = var.name
  project        = var.project
  memory_size_gb = var.memory_size_gb
  enable_apis    = var.enable_apis
}