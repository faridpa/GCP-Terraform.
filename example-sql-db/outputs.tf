output "name" {
  description = "The name for Cloud SQL instance"
  value       = module.postgresql.instance_name
}

output "psql_conn" {
  value       = module.postgresql.instance_connection_name
  description = "The connection name of the master instance to be used in connection strings"
}

output "psql_user_pass" {
  value = module.postgresql.generated_user_password
  description = "The password for the default user. If not set, a random one will be generated and available in the generated_user_password output variable."
  sensitive = true
}

output "public_ip_address" {
  description = "The first public (PRIMARY) IPv4 address assigned for the master instance"
  value       = module.postgresql.public_ip_address
}
