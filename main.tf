provider "google" {
  project = "brave-drummer-370205"
}


resource "google_compute_subnetwork" "subnet-us-central" {
  name          = "us-central"
  ip_cidr_range = "100.10.10.0/24"
  region        = "us-central1"
  network       = google_compute_network.axis-test.id  
}

resource "google_compute_network" "axis-test" {
  name                    = "axix-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_instance" "default" {
  name         = "test"
  machine_type = "e2-small"
  zone         = "us-central1-a"
  tags         = ["web"]

allow_stopping_for_update = true
  
  
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


resource "google_compute_firewall" "default-fire" {
  name    = "my-firewall"
  network = google_compute_network.axis-test.name 
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