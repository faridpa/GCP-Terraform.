billing_account_id        = "018BC9-549406-B7C8C3"
org_id                    = "392828863790"
region                    = "us-west1"
zone                      = "us-west1-c"
target_service_account    = "terraform-integral@secops-311714.iam.gserviceaccount.com"
folder_name               = "shared"
project_name              = "shared-vpc-project"
project_id                = "secops-311714"
network_name              = "shared-vpc"
subnetwork_1_name         = "shared-vpc-subnet-01"
subnetwork_2_name         = "shared-vpc-subnet-02"
ip_range_pods             = "shared-vpc-subnet-01-01"
ip_range_services         = "shared-vpc-subnet-01-02"
cluster_name              = "maincluster"
default_max_pods_per_node = "30"
projects                  = ["gke-project","db-project"]

// subnetwork                  = "first-network-subnet-01"
memcache_name                  = "ios-memcache"
memory_size_mb                 = "1024"
enable_apis                    = true
cpu_count                      = "1"
redis_name                     = "ios-redis"
memory_size_gb                 = "1"
pg_ha_name                     = "integral"
pg_ha_external_ip_range        = "0.0.0.0/0"

private_svc_ranges             = 3
db_tier                        = "db-g1-small"
members                        = [
    "group:devops-gp@integraldevops.com",
    "user:farid@integraldevops.com",
    "user:devops@integraldevops.com"
  ]

cloud_router_name              = "shared-vpc-router"
nat_gateway_name               = "shared-vpc-nat-gateway"