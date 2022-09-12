resource "google_compute_instance_template" "default" {
  name         = "arpan-igm-template"
  machine_type = "e2-small"
  tags         = ["allow-health-check"]

  network_interface {
    network    = "default"
    access_config {
      // Ephemeral public IP
    }
  }
  disk {
    source_image = "debian-cloud/debian-10"
    auto_delete  = true
    boot         = true
  }
