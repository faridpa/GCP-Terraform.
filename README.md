# gcp-terraform
Steps:

```
gcloud auth application-default login
terraform init
terraform plan -var 'folder_name=folder1' -var 'project_name=project1' --var-file main.tfvars
terraform apply -var 'folder_name=folder1' -var 'project_name=project1' --var-file main.tfvars
```
