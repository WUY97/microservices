resource "google_compute_instance" "node-1" {
  name         = "node-1"
  machine_type = var.MACHINE_TYPE
  zone         = var.ZONE

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts-arm64"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }

  service_account {
    email = var.TF_SERVICE_ACCOUNT
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  metadata_startup_script = templatefile("./scripts/node1_startup.sh", {
    swarm_yml = file("../project/swarm.production.yml")
  })

  tags = ["docker-vm-v4", "docker-vm-v6"]
}

resource "google_compute_instance" "node-2" {
  name         = "node-2"
  machine_type = var.MACHINE_TYPE
  zone         = var.ZONE

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts-arm64"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }

  service_account {
    email = "sa-gomicro-tf-mac@t-pulsar-412422.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  metadata_startup_script = templatefile("./scripts/node2_startup.sh", {})

  tags = ["docker-vm-v4", "docker-vm-v6"]
}
