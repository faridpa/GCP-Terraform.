# gcp-terraform

This Terraform code creates a folder, a project inside that folder. It also creates a service account for that project with IAM policies required for impersination.

Steps:
1. Run Terraform to create folder, project and service account with IAM policies. Replace folder1 with any other name.
```
gcloud auth application-default login
terraform init -backend-config="prefix=shared"
terraform plan -var 'folder_name=folder1' -var 'project_name=project1' --var-file main.tfvars
terraform apply -var 'folder_name=folder1' -var 'project_name=project1' --var-file main.tfvars
```
2. Make note of outputs in the end. You will use them in example/main.tfvars file.