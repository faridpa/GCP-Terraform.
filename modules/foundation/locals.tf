locals {
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
    for k, v in module.development-projects : k => v.project_id
  }
}