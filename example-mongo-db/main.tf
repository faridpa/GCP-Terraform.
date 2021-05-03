resource "mongodbatlas_cluster" "test" {
  project_id = mongodbatlas_project.project.id
  name        = var.name
  cluster_type = "REPLICASET"
  replication_specs {
    num_shards = 1
    regions_config {
      region_name     = var.region
      electable_nodes = 3
      priority        = 7
      read_only_nodes = 0
    }
  }
  mongo_db_major_version       = "4.4"

  //Provider Settings "block"
  provider_name                = "TENANT"
  provider_region_name         = var.region
  provider_backup_enabled      = false
  provider_instance_size_name  = "M2"
  backing_provider_name        = "GCP"
  auto_scaling_disk_gb_enabled = false
  disk_size_gb                 = 2
}

resource "mongodbatlas_database_user" "test" {
  username           = var.mongodb_atlas_database_username
  password           = var.mongodb_atlas_database_user_password
  project_id         = mongodbatlas_project.project.id
  auth_database_name = "admin"

  roles {
    role_name     = "readWrite"
    database_name = "dbforApp"
  }

  roles {
    role_name     = "readAnyDatabase"
    database_name = "admin"
  }

  labels {
    key   = "My Key"
    value = "My Value"
  }
}

resource "mongodbatlas_project_ip_whitelist" "test" {
  project_id = mongodbatlas_project.project.id
  ip_address = var.mongodb_atlas_whitelistip
  comment    = "ip address for tf acc testing"
}

resource "mongodbatlas_project_ip_whitelist" "myip" {
  project_id = mongodbatlas_project.project.id
  ip_address = chomp(data.http.myip.body)
  comment    = "IP Address for my home office"
}

resource "mongodbatlas_project" "project" {
  name = var.project_name
  org_id = var.mongodb_atlas_org_id
}
