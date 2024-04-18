
# variable "credentials" {
#   type = string
#   description = "Path to your Terraform Service Account Key .json - only needed if running terraform locally & you haven't already authorised with `gcloud auth` - we did in the install.sh script"
#   default     = "path/to/terraform-service-account/credentials.json"
# }

variable "project" {
  type        = string
  description = "The name of your GCP Project"
  default     = "my-gcp-project"

}

variable "location" {
  type        = string
  description = "The location your GCP Project is set up in e.g. EU or US"
  default     = "US"
}

variable "region" {
  type        = string
  description = "The Region your GCP Resources are set up in, referred to as ZONE in GCP e.g. 'us-central1'."
  default     = "us-central1"
}

variable "bq_dataset_name" {
  type        = string
  description = "BigQuery Dataset that the raw USGS data will be written to through Mage"
  default     = "my-bq-dataset"
}

variable "gcs_bucket_name" {
  type        = string
  description = "The name of your Google Cloud Storage Bucket"
  default     = "my-gcs-storage-bucket"
}

variable "gcs_storage_class" {
  type        = string
  description = "Storage class type for your bucket. https://cloud.google.com/storage/docs/storage-classes"
  default     = "STANDARD"
}

###############################################
# List GCP APIs to be enabled
###############################################

variable "gcp_service_list" {
  type        = list(string)
  description = "The list of APIs necessary for your project to work"
  default = [
    # "iam.googleapis.com", - VM creation only - also enables iamcredentials.googleapis.com at the same time 
    # "iamcredentials.googleapis.com", - VM creation only 
    "cloudapis.googleapis.com",
    "bigquery.googleapis.com",
    "cloudresourcemanager.googleapis.com"
  ]
}

###############################################
# VM Variables 
###############################################

variable "instance" {
  type        = string
  description = "The name of your virtual machine"
  default     = "my-virtual-machine"
}

variable "machine_type" {
  type        = string
  description = "type of virtual machine - Ref: https://cloud.google.com/compute/docs/general-purpose-machines"
  default     = "n1-standard-1"
}

variable "zone" {
  description = "Region for your virtual machine - same as project recommended"
  type        = string
  default     = "us-central1"
}