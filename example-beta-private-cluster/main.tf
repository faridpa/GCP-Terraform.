module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google//modules/beta-private-cluster-update-variant"
  project_id                 = var.project_id
  name                       = var.cluster_name
  region                     = var.region
  zones                      = ["us-west1-a", "us-west1-b", "us-west1-c"]
  network                    = var.network
  subnetwork                 = var.subnetwork
  ip_range_pods              = var.ip_range_pods
  ip_range_services          = var.ip_range_services
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
      cidr_block = "10.1.0.0/16"
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