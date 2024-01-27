resource "google_dns_record_set" "smolivdev-A-node-1" {
  name         = "node-1.smoliv.dev."
  type         = "A"
  ttl          = 300
  managed_zone = "smoliv-dev"
  rrdatas = [
    google_compute_instance.node-1.network_interface.0.access_config.0.nat_ip
  ]
}

resource "google_dns_record_set" "smolivdev-A-node-2" {
  name         = "node-2.smoliv.dev."
  type         = "A"
  ttl          = 300
  managed_zone = "smoliv-dev"
  rrdatas = [
    google_compute_instance.node-2.network_interface.0.access_config.0.nat_ip
  ]
}

resource "google_dns_record_set" "smolivdev-A-swarm" {
  name         = "swarm.smoliv.dev."
  type         = "A"
  ttl          = 300
  managed_zone = "smoliv-dev"
  rrdatas = [
    google_compute_instance.node-1.network_interface.0.access_config.0.nat_ip,
    google_compute_instance.node-2.network_interface.0.access_config.0.nat_ip
  ]
}