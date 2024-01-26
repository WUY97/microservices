resource "google_compute_instance" "node-1" {
  name         = "node-1"
  machine_type = "e2-small"
  zone         = "us-west1-b"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }

  tags = ["docker-vm-v4", "docker-vm-v6"]
}

resource "google_compute_instance" "node-2" {
  name         = "node-2"
  machine_type = "e2-small"
  zone         = "us-west1-b"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }
}
