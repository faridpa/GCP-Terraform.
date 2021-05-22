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
  activate_apis                  = ["compute.googleapis.com", "container.googleapis.com", "cloudbilling.googleapis.com", 
                                    "servicenetworking.googleapis.com", "sqladmin.googleapis.com", "redis.googleapis.com", "memcache.googleapis.com", "iap.googleapis.com"]
  labels                         = {"purpose":"shared-vpc"}
  lien                           = true
  sa_role                        = "roles/editor"
}

resource "google_compute_project_default_network_tier" "default" {
  project      = module.shared-vpc-project.project_id
  network_tier = "PREMIUM"
}

module "shared-vpc-network" {
  source                  = "terraform-google-modules/network/google"
  project_id              = module.shared-vpc-project.project_id
  version                 = "~> 3.2.2"
  network_name            = var.network_name
  routing_mode            = "REGIONAL"
  auto_create_subnetworks = false
  shared_vpc_host         = true
  subnets = [
    {
      subnet_name          = var.subnetwork_1_name
      subnet_ip            = "10.10.0.0/21"
      subnet_region        = var.region
      subnet_private_access = "true"
      subnet_flow_logs      = "false"
    },
    {
      subnet_name           = var.subnetwork_2_name
      subnet_ip             = "10.10.8.0/21"
      subnet_region         = var.region
      subnet_private_access = "true"
      subnet_flow_logs      = "false"
    },
  ]
  secondary_ranges = {
    (var.subnetwork_1_name) = [
      {
        range_name    = "${var.network_name}-subnet-01-01"
        ip_cidr_range = "192.168.64.0/24"
      },
      {
        range_name    = "${var.network_name}-subnet-01-02"
        ip_cidr_range = "192.168.65.0/24"
      },
    ]
    (var.subnetwork_2_name) = [
      {
        range_name    = "${var.network_name}-subnet-02-01"
        ip_cidr_range = "192.168.66.0/24"
      }
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

module "development-projects" {
  source               = "terraform-google-modules/project-factory/google//modules/svpc_service_project"
  for_each             = toset(var.projects)
  name                 = "development-${each.value}"
  random_project_id    = true
  org_id               = var.org_id
  folder_id            = lookup(lookup(module.folders.folders_map, "development"), "id")
  billing_account      = var.billing_account_id
  group_name           = "devops-gp"
  group_role           = "roles/owner"
  activate_apis        = ["compute.googleapis.com", "container.googleapis.com", "cloudbilling.googleapis.com", "servicenetworking.googleapis.com"]
  shared_vpc           = module.shared-vpc-project.project_id
  shared_vpc_subnets   = [lookup(lookup(module.shared-vpc-network.subnets, "${var.region}/${var.network_name}-subnet-01"),"self_link")]
  labels               = {"purpose":"gke"}
  sa_role              = "roles/editor"
  depends_on           = [module.shared-vpc-project,
                          module.shared-vpc-network
                         ]
}

module "private-service-access" {
  source             = "../private-service-access"
  private_svc_ranges = var.private_svc_ranges
  project_id         = module.shared-vpc-network.project_id
  vpc_network        = module.shared-vpc-network.network_name
  network_self_link  = module.shared-vpc-network.network_self_link
}