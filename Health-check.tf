resource "google_compute_health_check" "default" {
  name     = "arpan-hc"
  tcp_health_check {
    port = "80"
  }
}

resource "google_compute_firewall" "default" {
  name          = "arpan-fw-allow-hc"
  direction     = "INGRESS"
  network       = "default"
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16", "0.0.0.0/0"]
  allow {
    protocol = "tcp"
     ports    = ["80"]
  }
  target_tags = ["allow-health-check"]
}

