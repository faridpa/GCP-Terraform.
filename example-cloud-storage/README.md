# gcp-terraform
Example of using Google Terraform module with impersonation of a service account.

Steps:
1. Go to example directory:
```
cd example-cloud-storage
```
2. Replace project_id, target_service_account, bucket_name in main.tfvars file with values from the output.
3. Run Terraform module:
```
gcloud auth application-default login
terraform init
terraform plan --var-file main.tfvars
terraform apply --var-file main.tfvars
```
