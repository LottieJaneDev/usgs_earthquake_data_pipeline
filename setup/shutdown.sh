#!/bin/bash

# Print message indicating Terraform destruction is starting
echo "Destroying Terraform infrastructure..."

# Tear down Terraform infrastructure 
terraform destroy -auto-approve \
  -var="project=${GCP_PROJECT_NAME}" \
  -var="location=${GCP_LOCATION}" \
  -var="region=${GCP_REGION}" \
  -var="zone=${GCP_ZONE}" \
  -var="gcs_bucket_name=${GCP_GC_STORAGE_BUCKET_NAME}" \
  -var="bq_dataset_name=${GCP_BIGQUERY_DATASET_NAME}" \

# Check if Terraform destroy was successful
if [ $? -eq 0 ]; then
  echo "Terraform resources have been destroyed successfully!"
else
  echo "Terraform destruction failed."
  exit 1
fi

# Print message indicating Docker containers are being shut down
echo "Shutting down Docker containers..."

# Shut down Docker containers and remove them
docker stop $(docker ps -aq) && docker rm $(docker ps -aq)

# Print message indicating disconnection from the VM
echo "Disconnecting from the VM..."

# Disconnect from the VM by exiting the shell
exit

# Print final message indicating script completion
echo "Script execution completed."
