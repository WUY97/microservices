resource "google_container_cluster" "primary" {
  name     = "primary-cluster"
  location = var.REGION

  enable_autopilot = true
  deletion_protection = false

  node_config {
    disk_size_gb = 100
    machine_type = var.MACHINE_TYPE

    service_account = var.TF_SERVICE_ACCOUNT
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}