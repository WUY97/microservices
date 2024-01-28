resource "google_compute_instance_group" "default" {
  name        = "gomicro-instance-group"
  zone        = var.ZONE

  instances = [
    google_compute_instance.node-1.self_link,
    # google_compute_instance.node-2.self_link,
  ]

  named_port {
    name = "http"
    port = 80
  }
}

resource "google_compute_managed_ssl_certificate" "default" {
  name = "smolivdev-ssl-cert"
  managed {
    domains = ["swarm.smoliv.dev", "broker.smoliv.dev"]
  }
}

resource "google_compute_global_forwarding_rule" "default" {
  name       = "https-forwarding-rule"
  target     = google_compute_target_https_proxy.default.id
  port_range = "443"
}

resource "google_compute_target_https_proxy" "default" {
  name             = "https-proxy"
  url_map          = google_compute_url_map.default.id
  ssl_certificates = [google_compute_managed_ssl_certificate.default.id]
}

resource "google_compute_url_map" "default" {
  name            = "web-map"
  default_service = google_compute_backend_service.default.id
}

resource "google_compute_backend_service" "default" {
  name        = "web-backend-service"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 10
  health_checks = [google_compute_health_check.default.id]

  backend {
    group = google_compute_instance_group.default.id
  }
}

resource "google_compute_health_check" "default" {
  name               = "http-health-check"
  check_interval_sec = 30
  timeout_sec        = 10
  healthy_threshold  = 2
  unhealthy_threshold = 2

  http_health_check {
    port = 80
    request_path = "/"
  }
}