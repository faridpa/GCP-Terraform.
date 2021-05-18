locals {
  subnet_01 = "${var.network_name}-subnet-01"
  subnet_02 = "${var.network_name}-subnet-02"
  network_routes = [
    {
      name              = "${var.network_name}-egress-inet"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags              = "egress-inet"
      next_hop_internet = "true"
    },
  ]
  project_ids = {
    for k, v in module.development-projects : k => v.project_id }

  //
  read_replica_ip_configuration = {
    ipv4_enabled    = true
    require_ssl     = false
    private_network = "projects/${module.shared-vpc-network.project_id}/global/networks/${module.shared-vpc-network.network_name}"
    authorized_networks = [
  {
  name  = "${lookup(local.project_ids,"db-project")}-cidr"
      value = var.pg_ha_external_ip_range
   },
    ]
  }
}