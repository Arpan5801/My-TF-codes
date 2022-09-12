resource "google_compute_instance" "instance" {
  name         = "test"
  machine_type = "e2-medium"
  zone         = "us-central1-a"


  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10" 
    }
  }

   network_interface {
    network = "default"
  
   access_config {
      // Ephemeral public IP
    }
  }

  metadata_startup_script = "#! /bin/bash ; apt -y install apache2"
}


resource "google_compute_firewall" "default-fire" {
  name    = "my-firewall"
  network = "default"
  priority = "1000"

  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["80", "22", "25"]
  }
}
