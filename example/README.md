# gcp-terraform
Steps:

```
gcloud auth application-default login
terraform init
terraform plan --var-file main.tfvars
terraform apply --var-file main.tfvars
```
