variable "billing_account_id" {}
variable "org_id" {}
variable "region" {}
variable "project_name" {}
variable "network_name" {}
variable "projects" {
  type = list(string)
}

variable "subnetwork_1_name" {}
variable "subnetwork_2_name" {}
variable "ip_range_pods" {}