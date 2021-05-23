variable "project_id" {}
variable "zone" {}
variable "subnetwork_self_link" {}
variable "network_self_link" {}
variable "members" {
  type = list(string)
}
variable "shielded_vm" {}