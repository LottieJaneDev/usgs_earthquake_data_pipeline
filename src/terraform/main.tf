##################################################################
# Google Cloud Platform Resources
###################################################################

# Provider
# Ref: https://registry.terraform.io/providers/hashicorp/google/latest

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.23.0"
    }
  }
}

provider "google" {
  # credentials = file(var.credentials)
  project = var.project
  region  = var.region
}

##################################################################
# Enable APIs for the Project
###################################################################

# APIs - Ref: https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/google_project_service

resource "google_project_service" "enabled_apis" {
  project  = var.project
  for_each = toset(var.gcp_service_list)
  service  = each.key

  disable_on_destroy = false
}

##################################################################
# Google Cloud Storage Bucket
###################################################################

# Data Lake Bucket
# Ref: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket

resource "google_storage_bucket" "gcs_bucket_name" {
  name          = var.gcs_bucket_name
  location      = var.location
  force_destroy = true


  labels = {
    environment = "production"
    team        = "data-engineering"
  }

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type = "Delete"
    }
  }

  logging {
    log_bucket = "my-log-bucket"
  }

  ###### You can't have retention & versioning so it would depend on your use case ######

  # retention_policy {
  #   retention_period = 60
  #   is_locked        = true
  # }

}

##################################################################
# BigQuery Dataset
###################################################################

# Data Warehouse
# Ref: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_dataset

resource "google_bigquery_dataset" "bq_dataset" {
  dataset_id = var.bq_dataset_name
  location   = var.location

  description = "This dataset contains the USGS raw data from Mage Ingestion"

  default_table_expiration_ms = 2592000000 # 30 days

  default_partition_expiration_ms = 2592000000 # 30 days

  labels = {
    environment = "development"
    department  = "data-engineering"
  }

  provisioner "local-exec" {
    command = "echo 'Waiting for the API to be enabled....'; sleep 20"
  }

  # This provisioner ensures a delay of 20 seconds after the google_project_service.enabled_apis resource is created
  depends_on = [google_project_service.enabled_apis]

}
