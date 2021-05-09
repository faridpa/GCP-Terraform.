// resource "google_compute_project_default_network_tier" "default" {
//   project      = var.project_id
//   network_tier = "PREMIUM"
// }
// module "vpc-network" {
//   source       = "terraform-google-modules/network/google"
//   version      = "~> 3.2.0"
//   project_id   = var.project_id
//   network_name = var.network_name
//   routing_mode = "REGIONAL"
//   auto_create_subnetworks = false
//   subnets = [
//     {
//       subnet_name   = local.subnet_01
//       subnet_ip     = "10.10.10.0/24"
//       subnet_region = var.region
//     },
//     {
//       subnet_name           = local.subnet_02
//       subnet_ip             = "10.10.20.0/24"
//       subnet_region         = var.region
//       subnet_private_access = "true"
//       subnet_flow_logs      = "true"
//     },
//   ]
//   secondary_ranges = {
//     (local.subnet_01) = [
//       {
//         range_name    = "${local.subnet_01}-01"
//         ip_cidr_range = "192.168.64.0/24"
//       },
//       {
//         range_name    = "${local.subnet_01}-02"
//         ip_cidr_range = "192.168.65.0/24"
//       },
//     ]
//     (local.subnet_02) = [
//       {
//         range_name    = "${local.subnet_02}-01"
//         ip_cidr_range = "192.168.66.0/24"
//       },
//     ]
//   }
//   routes = local.network_routes
//   firewall_rules = [
//     {
//       name      = "allow-ssh-ingress"
//       direction = "INGRESS"
//       ranges    = ["0.0.0.0/0"]
//       allow = [{
//         protocol = "tcp"
//         ports    = ["22"]
//       }]
//       log_config = {
//         metadata = "INCLUDE_ALL_METADATA"
//       }
//     },
//     {
//       name      = "deny-udp-egress"
//       direction = "INGRESS"
//       ranges    = ["0.0.0.0/0"]
//       deny = [{
//         protocol = "udp"
//         ports    = null
//       }]
//     },
//   ]
// }