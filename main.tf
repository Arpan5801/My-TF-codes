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