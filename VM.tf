resource "google_compute_instance" "default" {
  name         = "test"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }



  network_interface {
    network = google_compute_network.axis-test.id
    subnetwork = google_compute_subnetwork.subnet-us-central.id
  

  access_config {
      // Ephemeral public IP
    }
  }
}
