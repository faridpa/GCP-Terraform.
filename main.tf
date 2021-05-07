resource "random_id" "id" {
  byte_length = 4
  prefix      = var.project_name
}

# resource "google_folder" "folder" {
#   // provider     = google-beta
#   display_name = var.folder_name
#   parent       = "organizations/${var.org_id}"
# }

# resource "google_project" "project" {
#   // provider        = google-beta
#   name            = var.project_name
#   project_id      = random_id.id.hex
#   billing_account = var.billing_account
#   folder_id       = google_folder.folder.name
# }

# resource "google_project_service" "service" {
#   // provider = google-beta
#   for_each = toset([
#     "compute.googleapis.com",
#     "cloudresourcemanager.googleapis.com",
#     "cloudbilling.googleapis.com",
#     "iam.googleapis.com",
#     "compute.googleapis.com",
#     "serviceusage.googleapis.com",
#     "sqladmin.googleapis.com"
#   ])
#   service = each.key
#   project            = google_project.project.project_id
#   disable_on_destroy = false
# }

# resource "google_service_account" "prj-service-account" {
#   // provider     = google-beta
#   account_id   = "${google_project.project.project_id}-sa"
#   display_name = "Service Account for ${google_project.project.project_id} project"
#   project      = google_project.project.project_id
#   // depends_on   = [google_project_service.service]
# }

# resource "google_service_account_iam_binding" "impersination-iam" {
#   // provider           = google-beta
#   service_account_id = google_service_account.prj-service-account.name
#   role               = "roles/iam.serviceAccountUser"
#   members            = [
#     "serviceAccount:${var.target_service_account}",
#     "user:devops@integraldevops.com",
#     "user:farid@integraldevops.com",
#     "user:osman@integraldevops.com",
#   ]
# //   condition {
# //     title       = "expires_after_2019_12_31"
# //     description = "Expiring at midnight of 2019-12-31"
# //     expression  = "request.time < timestamp(\"2020-01-01T00:00:00Z\")"
# //   }
# }

# resource "google_service_account_iam_binding" "token-creator-iam" {
#   // provider           = google-beta
#   service_account_id = google_service_account.prj-service-account.name
#   role               = "roles/iam.serviceAccountTokenCreator"
#   members            = [
#     "serviceAccount:${var.target_service_account}",
#     "user:devops@integraldevops.com",
#     "user:farid@integraldevops.com",
#     "user:osman@integraldevops.com",
#   ]
//   condition {
//     title       = "expires_after_2019_12_31"
//     description = "Expiring at midnight of 2019-12-31"
//     expression  = "request.time < timestamp(\"2020-01-01T00:00:00Z\")"
//   }
# }

# resource "google_project_iam_binding" "binding-iam-1" {
#   // provider = google-beta
#   project  = google_project.project.project_id
#   role     = "roles/editor"
#   members  = [
#     "serviceAccount:${google_service_account.prj-service-account.email}",
#   ]
# //   condition {
# //     title       = "expires_after_2019_12_31"
# //     description = "Expiring at midnight of 2019-12-31"
# //     expression  = "request.time < timestamp(\"2020-01-01T00:00:00Z\")"
# //   }
# }

# resource "google_project_iam_binding" "binding-iam-2" {
#   // provider = google-beta
#   project  = google_project.project.project_id
#   role     = "roles/resourcemanager.projectIamAdmin"
#   members  = [
#     "serviceAccount:${google_service_account.prj-service-account.email}",
#   ]
# //   condition {
# //     title       = "expires_after_2019_12_31"
# //     description = "Expiring at midnight of 2019-12-31"
# //     expression  = "request.time < timestamp(\"2020-01-01T00:00:00Z\")"
# //   }
# }

# // my changes

module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google//modules/beta-private-cluster-update-variant"
  project_id                 = var.project_id
  name                       = var.cluster_name
  region                     = var.region
  zones                      = ["us-west1-a", "us-west1-b", "us-west1-c"]
  network                    = module.vpc-network.network_self_link
  subnetwork                 = local.subnet_01 
  ip_range_pods              = var.ip_range_pods
  ip_range_services          = var.ip_range_services
  default_max_pods_per_node  = var.default_max_pods_per_node
  http_load_balancing        = true
  horizontal_pod_autoscaling = true
  network_policy             = false
  enable_private_endpoint    = true
  enable_private_nodes       = true
  master_ipv4_cidr_block     = "10.0.0.0/28"
  istio = true
  cloudrun = true
  dns_cache = false
  master_authorized_networks = [
    {
      cidr_block = "10.10.10.0/24"
      display_name = "Private"
    }
    ]


  node_pools = [
    {
      name               = "default-node-pool"
      machine_type       = "n1-standard-2"
      node_locations     = "us-west1-b,us-west1-c"
      min_count          = 1
      max_count          = 1
      local_ssd_count    = 0
      disk_size_gb       = 10
      disk_type          = "pd-standard"
      image_type         = "COS"
      auto_repair        = true
      auto_upgrade       = true
      service_account    = var.target_service_account
      preemptible        = false
      initial_node_count = 1
    },
  ]

  node_pools_oauth_scopes = {
    all = []

    default-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_taints = {
    all = []

    default-node-pool = [
      {
        key    = "default-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
}

module "private-service-access" {
  source      = "GoogleCloudPlatform/sql-db/google//modules/private_service_access"
  version     = "4.5"
  project_id  = var.project_id
  vpc_network = module.vpc-network.network_self_link
 }
module "memcache" {
  source         = "terraform-google-modules/memorystore/google//modules/memcache"
  name           = var.name
  project        = can(module.private-service-access.peering_completed) ? var.project_id : ""
  memory_size_mb = var.memory_size_mb
  enable_apis    = var.enable_apis
  cpu_count      = var.cpu_count
  region         = var.region
}


module "memorystore" {
  source         = "terraform-google-modules/memorystore/google"
  name           = var.name_redis
  project        = var.project_id
  memory_size_gb = var.memory_size_gb
  enable_apis    = var.enable_apis
}

module "postgresql" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
  name                 = var.pg_ha_name
  random_instance_name = true
  database_version     = "POSTGRES_9_6"
  project_id           = var.project_id
  zone                 = "us-west1-a"
  region               = "us-west1"
  tier                 = "db-f1-micro"
  deletion_protection  = false
  create_timeout       = "20m"
  ip_configuration = {
    ipv4_enabled    = true
    require_ssl     = false
    private_network = null
    authorized_networks = [
      {
        name  = "${var.project_id}-cidr"
        value = var.pg_ha_external_ip_range
      },
    ]
  }
  backup_configuration = {
    enabled                        = true
    start_time                     = "21:00"
    location                       = null
    point_in_time_recovery_enabled = false
  }
  read_replica_name_suffix = "-test"
  read_replicas = [
    {
      name             = "0"
      zone             = "us-west1-a"
      tier             = "db-f1-micro"
      ip_configuration = local.read_replica_ip_configuration
      database_flags   = [{ name = "autovacuum", value = "off" }]
      disk_autoresize  = null
      disk_size        = null
      disk_type        = "PD_HDD"
      user_labels      = { bar = "baz" }
    },
    {
      name             = "1"
      zone             = "us-west1-b"
      tier             = "db-f1-micro"
      ip_configuration = local.read_replica_ip_configuration
      database_flags   = [{ name = "autovacuum", value = "off" }]
      disk_autoresize  = null
      disk_size        = null
      disk_type        = "PD_HDD"
      user_labels      = { bar = "baz" }
    },
    {
      name             = "2"
      zone             = "us-west1-c"
      tier             = "db-f1-micro"
      ip_configuration = local.read_replica_ip_configuration
      database_flags   = [{ name = "autovacuum", value = "off" }]
      disk_autoresize  = null
      disk_size        = null
      disk_type        = "PD_HDD"
      user_labels      = { bar = "baz" }
    },
  ]

  db_name      = var.pg_ha_name
  db_charset   = "UTF8"
  db_collation = "en_US.UTF8"

  additional_databases = [
    {
      name      = "${var.pg_ha_name}-additional"
      charset   = "UTF8"
      collation = "en_US.UTF8"
    },
  ]

  user_name     = "tftest"
  user_password = "foobar"

  additional_users = [
    {
      name     = "tftest2"
      password = "abcdefg"
      host     = "localhost"
    },
    {
      name     = "tftest3"
      password = "abcdefg"
      host     = "localhost"
    },
  ]
}

# module "vpc-secondary-ranges" {
#   source       = "terraform-google-modules/network/google"
#   project_id   = var.project_id
#   network_name = var.network_name
 


#   subnets = [
#     {
#       subnet_name   = "{$local.subnet_01}"
#       subnet_ip     = "10.10.10.0/24"
#       subnet_region = "us-west1"
#     },
#     {
#       subnet_name           = "${local.subnet_02}"
#       subnet_ip             = "10.10.20.0/24"
#       subnet_region         = "us-west1"
#       subnet_private_access = "true"
#       subnet_flow_logs      = "true"
#     },
#     {
#       subnet_name               = "${local.subnet_03}"
#       subnet_ip                 = "10.10.30.0/24"
#       subnet_region             = "us-west1"
#       subnet_flow_logs          = "true"
#       subnet_flow_logs_interval = "INTERVAL_15_MIN"
#       subnet_flow_logs_sampling = 0.9
#       subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
#     },
#     {
#       subnet_name   = "${local.subnet_04}"
#       subnet_ip     = "10.10.40.0/24"
#       subnet_region = "us-west1"
#     },
#   ]

#   secondary_ranges = {
#     "${local.subnet_01}" = [
#       {
#         range_name    = "${local.subnet_01}-01"
#         ip_cidr_range = "192.168.64.0/24"
#       },
#       {
#         range_name    = "${local.subnet_01}-02"
#         ip_cidr_range = "192.168.65.0/24"
#       },
#     ]

#     "${local.subnet_02}" = []

#     "${local.subnet_03}" = [
#       {
#         range_name    = "${local.subnet_03}-01"
#         ip_cidr_range = "192.168.66.0/24"
#       },
#     ]
#   }

#   firewall_rules = [
#     {
#       name      = "allow-ssh-ingress"
#       direction = "INGRESS"
#       ranges    = ["0.0.0.0/0"]
#       allow = [{
#         protocol = "tcp"
#         ports    = ["22"]
#       }]
#       log_config = {
#         metadata = "INCLUDE_ALL_METADATA"
#       }
#     },
#     {
#       name      = "deny-udp-egress"
#       direction = "INGRESS"
#       ranges    = ["0.0.0.0/0"]
#       deny = [{
#         protocol = "udp"
#         ports    = null
#       }]
#     },
#   ]
# 

