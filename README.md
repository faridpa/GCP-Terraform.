# gcp-terraform

This Terraform code creates a folder, a project inside that folder. It also creates a service account for that project with IAM policies required for impersination.

Steps:

```
gcloud auth application-default login
terraform init
terraform plan -var 'folder_name=folder1' -var 'project_name=project1' --var-file main.tfvars
terraform apply -var 'folder_name=folder1' -var 'project_name=project1' --var-file main.tfvars
```
