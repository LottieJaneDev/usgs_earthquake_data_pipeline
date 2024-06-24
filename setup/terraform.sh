#!/bin/bash

# export the .env file at project root to the current shell session 
# export $(grep -v '^#' "${ENV_FILE}" | xargs -d '\n') - DOESN'T WORK 

cd ~/usgs_earthquake_data_pipeline/ 

source .env 

cd ~/usgs_earthquake_data_pipeline/terraform/

# Activate the Terraform Service Account
gcloud auth activate-service-account --key-file="$VM_TERRAFORM_SERVICE_ACCOUNT_FILE_PATH"

# use gcloud to enable API's due to newer restrictions see StackOverflow thread https://stackoverflow.com/questions/59055395/can-i-automatically-enable-apis-when-using-gcp-cloud-with-terraform
# gcloud services enable bigquery.googleapis.com serviceusage.googleapis.com cloudapis.googleapis.com cloudresourcemanager.googleapis.com --project "$GCP_PROJECT_NAME"

# sleep 180 # "If you enabled this API recently, wait a few minutes for the action to propagate to our systems and retry." GCP needs time to refresh the policies 

# format .tf files 
terraform fmt

# initialise Terraform
terraform init

# validata Terraform
terraform validate

## Run Terraform commands using the exported variables

# Plan Terraform resources
terraform plan \
  -var="project=${GCP_PROJECT_NAME}" \
  -var="location=${GCP_LOCATION}" \
  -var="region=${GCP_REGION}" \
  -var="zone=${GCP_ZONE}" \
  -var="gcs_bucket_name=${GCP_GC_STORAGE_BUCKET_NAME}" \
  -var="bq_dataset_name=${GCP_BIGQUERY_DATASET_NAME}" \
  -out=terraform.plan


echo "Terraform resources have been planned... Terraform apply will now commence..."
sleep 10

# Build Terraform resources
terraform apply -auto-approve\
  -var="project=${GCP_PROJECT_NAME}" \
  -var="location=${GCP_LOCATION}" \
  -var="region=${GCP_REGION}" \
  -var="zone=${GCP_ZONE}" \
  -var="gcs_bucket_name=${GCP_GC_STORAGE_BUCKET_NAME}" \
  -var="bq_dataset_name=${GCP_BIGQUERY_DATASET_NAME}" \

echo "Terraform resources have been provisioned! Head back to setup.md for the next step!"
sleep 10


####################################################################
# Uncomment this final block & run again to destroy all resources ##
####################################################################

# terraform destroy -auto-approve \
#   -var="project=${GCP_PROJECT_NAME}" \
#   -var="location=${GCP_LOCATION}" \
#   -var="region=${GCP_REGION}" \
#   -var="zone=${GCP_ZONE}" \
#   -var="gcs_bucket_name=${GCP_GC_STORAGE_BUCKET_NAME}" \
#   -var="bq_dataset_name=${GCP_BIGQUERY_DATASET_NAME}" \

# echo "Terraform resources have been destoyed!"
