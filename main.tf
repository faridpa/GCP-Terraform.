module "folders" {
  source  = "terraform-google-modules/folders/google"
  version = "~> 3.0"
  parent  = "organizations/${var.org_id}"
  names = [
    "root",
    "development",
    "staging",
    "production",
  ]
  set_roles = true
  per_folder_admins = {
    development = "group:development@integraldevops.com"
    staging     = "group:staging@integraldevops.com"
    production  = "group:production@integraldevops.com"
  }
  all_folder_admins = [
    "group:devops-gp@integraldevops.com",
  ]
  folder_admin_roles = [
    "roles/owner",
    "roles/resourcemanager.folderViewer",
    "roles/resourcemanager.projectCreator",
    "roles/compute.networkAdmin"
  ]
}

module "shared-vpc-project" {
  source                         = "terraform-google-modules/project-factory/google"
  name                           = var.project_name
  random_project_id              = true
  org_id                         = var.org_id
  folder_id                      = lookup(lookup(module.folders.folders_map, "root"), "id")
  billing_account                = var.billing_account_id
  enable_shared_vpc_host_project = true
  group_name                     = "devops-gp"
  group_role                     = "roles/owner"
  activate_apis                  = ["compute.googleapis.com", "container.googleapis.com", "cloudbilling.googleapis.com"]
  labels                         = {"purpose":"shared-vpc"}
  lien                           = true
  sa_role                        = "roles/editor"
}

resource "google_compute_project_default_network_tier" "default" {
  project      = module.shared-vpc-project.project_id
  network_tier = "PREMIUM"
}

module "vpc-network" {
  source                  = "terraform-google-modules/network/google"
  project_id              = module.shared-vpc-project.project_id
  version                 = "~> 3.2.2"
  network_name            = var.network_name
  routing_mode            = "REGIONAL"
  auto_create_subnetworks = false
  shared_vpc_host         = true
  subnets = [
    {
      subnet_name          = local.subnet_01
      subnet_ip            = "10.10.10.0/24"
      subnet_region        = var.region
      subnet_private_access = "true"
      subnet_flow_logs      = "false"
    },
    {
      subnet_name           = local.subnet_02
      subnet_ip             = "10.10.20.0/24"
      subnet_region         = var.region
      subnet_private_access = "true"
      subnet_flow_logs      = "false"
    },
  ]
  secondary_ranges = {
    (local.subnet_01) = [
      {
        range_name    = "${local.subnet_01}-01"
        ip_cidr_range = "192.168.64.0/24"
      },
      {
        range_name    = "${local.subnet_01}-02"
        ip_cidr_range = "192.168.65.0/24"
      },
    ]
    (local.subnet_02) = [
      {
        range_name    = "${local.subnet_02}-01"
        ip_cidr_range = "192.168.66.0/24"
      },
    ]
  }
  routes = local.network_routes
  firewall_rules = [
    {
      name      = "allow-ssh-ingress"
      direction = "INGRESS"
      ranges    = ["0.0.0.0/0"]
      allow = [{
        protocol = "tcp"
        ports    = ["22"]
      }]
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    },
    {
      name      = "deny-udp-egress"
      direction = "INGRESS"
      ranges    = ["0.0.0.0/0"]
      deny = [{
        protocol = "udp"
        ports    = null
      }]
    },
  ]
}

// module "development-gke-project" {
//   source               = "terraform-google-modules/project-factory/google"
//   for_each             = toset(var.projects)
//   name                 = "development-${each.value}"
//   random_project_id    = true
//   org_id               = var.org_id
//   folder_id            = lookup(lookup(module.folders.folders_map, "development"), "id")
//   billing_account      = var.billing_account_id
//   group_name           = "devops-gp"
//   group_role           = "roles/owner"
//   activate_apis        = ["compute.googleapis.com", "container.googleapis.com", "cloudbilling.googleapis.com"]
//   svpc_host_project_id = module.shared-vpc-project.project_id
//   shared_vpc_subnets   = [lookup(lookup(module.vpc-network.subnets, "${var.region}/${local.subnet_01}"),"self_link")]
//   labels               = {"purpose":"gke"}
//   sa_role              = "roles/editor"
// }

// module "gke" {
//   source                     = "terraform-google-modules/kubernetes-engine/google//modules/beta-private-cluster-update-variant"
//   project_id                 = module.development-gke-project.project_id
//   network_project_id         = module.shared-vpc-project.project_id
//   name                       = var.cluster_name
//   region                     = var.region
//   zones                      = data.google_compute_zones.available.names
//   network                    = module.vpc-network.network_name
//   subnetwork                 = local.subnet_01
//   ip_range_pods              = "${local.subnet_01}-01"
//   ip_range_services          = "${local.subnet_01}-02"
//   default_max_pods_per_node  = var.default_max_pods_per_node
//   http_load_balancing        = true
//   horizontal_pod_autoscaling = true
//   network_policy             = false
//   enable_private_endpoint    = true
//   enable_private_nodes       = true
//   master_ipv4_cidr_block     = "10.0.0.0/28"
//   remove_default_node_pool   = true
//   istio = true
//   cloudrun = true
//   dns_cache = false
//   master_authorized_networks = [
//     {
//       cidr_block = "10.10.10.0/24"
//       display_name = "Private"
//     }
//   ]
//   node_pools = [
//     {
//       name               = "default-node-pool"
//       machine_type       = "n1-standard-2"
//       node_locations     = join(",", data.google_compute_zones.available.names)
//       min_count          = 1
//       max_count          = 1
//       local_ssd_count    = 0
//       disk_size_gb       = 10
//       disk_type          = "pd-standard"
//       image_type         = "COS"
//       auto_repair        = true
//       auto_upgrade       = true
//       service_account    = module.development-gke-project.service_account_email
//       preemptible        = false
//       initial_node_count = 1
//     },
//   ]
//   node_pools_oauth_scopes = {
//     all = []
//     default-node-pool = [
//       "https://www.googleapis.com/auth/cloud-platform",
//     ]
//   }
//   node_pools_labels = {
//     all = {}
//     default-node-pool = {
//       default-node-pool = true
//     }
//   }
//   node_pools_metadata = {
//     all = {}
//     default-node-pool = {
//       node-pool-metadata-custom-value = "my-node-pool"
//     }
//   }
//   node_pools_taints = {
//     all = []
//     default-node-pool = [
//       {
//         key    = "default-node-pool"
//         value  = true
//         effect = "PREFER_NO_SCHEDULE"
//       },
//     ]
//   }
//   node_pools_tags = {
//     all = []
//     default-node-pool = [
//       "default-node-pool",
//     ]
//   }
// }

// module "postgresql" {
//   source  = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
//   name                 = var.pg_ha_name
//   random_instance_name = true
//   database_version     = "POSTGRES_9_6"
//   project_id           = var.project_id
//   zone                 = "us-west1-a"
//   region               = "us-west1"
//   tier                 = "db-f1-micro"
//   deletion_protection  = false
//   create_timeout       = "20m"
//   ip_configuration = {
//     ipv4_enabled    = true
//     require_ssl     = false
//     private_network = null
//     authorized_networks = [
//       {
//         name  = "${var.project_id}-cidr"
//         value = var.pg_ha_external_ip_range
//       },
//     ]
//   }
//   backup_configuration = {
//     enabled                        = true
//     start_time                     = "21:00"
//     location                       = null
//     point_in_time_recovery_enabled = false
//   }
//   read_replica_name_suffix = "-test"
//   read_replicas = [
//     {
//       name             = "0"
//       zone             = "us-west1-a"
//       tier             = "db-f1-micro"
//       ip_configuration = local.read_replica_ip_configuration
//       database_flags   = [{ name = "autovacuum", value = "off" }]
//       disk_autoresize  = null
//       disk_size        = null
//       disk_type        = "PD_HDD"
//       user_labels      = { bar = "baz" }
//     },
//     {
//       name             = "1"
//       zone             = "us-west1-b"
//       tier             = "db-f1-micro"
//       ip_configuration = local.read_replica_ip_configuration
//       database_flags   = [{ name = "autovacuum", value = "off" }]
//       disk_autoresize  = null
//       disk_size        = null
//       disk_type        = "PD_HDD"
//       user_labels      = { bar = "baz" }
//     },
//     {
//       name             = "2"
//       zone             = "us-west1-c"
//       tier             = "db-f1-micro"
//       ip_configuration = local.read_replica_ip_configuration
//       database_flags   = [{ name = "autovacuum", value = "off" }]
//       disk_autoresize  = null
//       disk_size        = null
//       disk_type        = "PD_HDD"
//       user_labels      = { bar = "baz" }
//     },
//   ]

//   db_name      = var.pg_ha_name
//   db_charset   = "UTF8"
//   db_collation = "en_US.UTF8"

//   additional_databases = [
//     {
//       name      = "${var.pg_ha_name}-additional"
//       charset   = "UTF8"
//       collation = "en_US.UTF8"
//     },
//   ]

//   user_name     = "tftest"
//   user_password = "foobar"

//   additional_users = [
//     {
//       name     = "tftest2"
//       password = "abcdefg"
//       host     = "localhost"
//     },
//     {
//       name     = "tftest3"
//       password = "abcdefg"
//       host     = "localhost"
//     },
//   ]
// }
























// module "private-service-access" {
//   source      = "GoogleCloudPlatform/sql-db/google//modules/private_service_access"
//   version     = "4.5"
//   project_id  = var.project_id
//   vpc_network = module.vpc-network.network_self_link
//  }

// module "memcache" {
//   source         = "terraform-google-modules/memorystore/google//modules/memcache"
//   name           = var.name
//   project        = can(module.private-service-access.peering_completed) ? var.project_id : ""
//   memory_size_mb = var.memory_size_mb
//   enable_apis    = var.enable_apis
//   cpu_count      = var.cpu_count
//   region         = var.region
// }

// module "memorystore" {
//   source         = "terraform-google-modules/memorystore/google"
//   name           = var.name_redis
//   project        = var.project_id
//   memory_size_gb = var.memory_size_gb
//   enable_apis    = var.enable_apis
// }
