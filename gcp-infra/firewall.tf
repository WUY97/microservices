resource "google_compute_firewall" "docker-firewall-v4" {
  name    = "allow-docker-v4"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443", "2377", "7946", "8025"]
  }

  allow {
    protocol = "udp"
    ports    = ["7946", "4789"]
  }

  target_tags   = ["docker-vm-v4"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "docker-firewall-v6" {
  name    = "allow-docker-v6"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443", "2377", "7946", "8025"]
  }

  allow {
    protocol = "udp"
    ports    = ["7946", "4789"]
  }

  target_tags   = ["docker-vm-v6"]
  source_ranges = ["::/0"]
}

