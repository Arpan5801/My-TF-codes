resource "google_compute_firewall" "default1" {
  name    = "my-firewall"
  network = google_compute_network.custom-testing.name 
  priority = "1000"

  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["80", "22", "25"]
  }

    target_tags = ["web"]
}
