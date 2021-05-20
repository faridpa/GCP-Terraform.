output "project_ids" {
  value = local.project_ids
}

output "shared_vpc_project_id" {
  value = module.shared-vpc-project.project_id
}

output "shared_vpc_network_name" {
  value = module.shared-vpc-network.network_name
}

output "shared_vpc_subnets_names" {
  value = module.shared-vpc-network.subnets_names
}

output "shared_vpc_subnets_secondary_ranges" {
  value = module.shared-vpc-network.subnets_secondary_ranges
}

output "shared_vpc_network_self_link" {
  value = module.shared-vpc-network.network_self_link
}