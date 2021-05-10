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
    for k, v in module.development-gke-project : k => v.project_id }

  //
  read_replica_ip_configuration = {
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
}