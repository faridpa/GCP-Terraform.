locals {
  read_replica_ip_configuration = {
    ipv4_enabled    = true
    require_ssl     = false
    private_network = null
   }
}