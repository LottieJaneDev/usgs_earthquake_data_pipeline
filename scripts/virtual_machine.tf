##################################################################
# Virtual machine
###################################################################

# If you already have Terraform installed locally, you can use this script to spin up the VM

resource "google_service_account" "default" {
  account_id   = "your_email_address"
  display_name = "Your full name"
}

resource "google_project_iam_binding" "example_owner_binding" {
  project = google_project.default.project_id
  role    = "roles/owner"

  members = [
    "serviceAccount:${google_service_account.default.email}"
  ]
}

resource "google_compute_instance" "instance" {
  name                = var.instance
  machine_type        = var.machine_type
  zone                = var.region
  project             = var.project
  can_ip_forward      = false
  deletion_protection = false

  confidential_instance_config {
    enable_confidential_compute = false
  }

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-lts"
      size  = 60
      type  = "pd-standard"
    }
  }

  guest_accelerator {
    type  = "VIRTIO_SCSI_MULTIQUEUE"
    count = 1
  }

  guest_accelerator {
    type  = "SEV_CAPABLE"
    count = 1
  }

  guest_accelerator {
    type  = "SEV_SNP_CAPABLE"
    count = 1
  }

  guest_accelerator {
    type  = "SEV_LIVE_MIGRATABLE"
    count = 1
  }

  guest_accelerator {
    type  = "SEV_LIVE_MIGRATABLE_V2"
    count = 1
  }

  guest_accelerator {
    type  = "IDPF"
    count = 1
  }

  guest_accelerator {
    type  = "UEFI_COMPATIBLE"
    count = 1
  }

  guest_accelerator {
    type  = "GVNIC"
    count = 1
  }

  network_interface {
    network    = "default"
    subnetwork = "default"
    access_config {
      network_tier = "PREMIUM"
    }
  }

  shielded_instance_config {
    enable_secure_boot          = false
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }
}
