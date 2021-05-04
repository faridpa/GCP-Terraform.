locals {
  read_replica_ip_configuration = {
    ipv4_enabled    = false
    require_ssl     = false
    private_network = module.network-safer-postgresql-simple.network_self_link
    authorized_networks = [
      {
        name  = "${var.project_id}-cidr"
        value = var.pg_ha_external_ip_range
      },
    ]
  }
  ip_configuration = {
    ipv4_enabled        = false
    private_network     = module.network-safer-postgresql-simple.network_self_link
    require_ssl         = false
    authorized_networks = []
  }
}
