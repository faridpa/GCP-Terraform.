# gcp-terraform
Example of using Google Terraform module with impersonation of a service account.

Steps:

```
gcloud auth application-default login
terraform init
terraform plan --var-file main.tfvars
terraform apply --var-file main.tfvars
```
