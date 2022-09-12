resource "google_compute_subnetwork" "subnet-us-central" {
  name          = "us-central"
  ip_cidr_range = "10.10.0.0/22"
  region        = "us-central1"
  network       = google_compute_network.custom-testing.id  
}


resource "google_compute_subnetwork" "subnet-us-east" {
  name          = "us-east"
  ip_cidr_range = "10.1.0.0/18"
  region        = "us-east1"
  network       = google_compute_network.custom-testing.id  
}

resource "google_compute_network" "custom-testing" {
  name                    = "anb-vpc"
  auto_create_subnetworks = false
}


resource "google_compute_subnetwork" "subnet-asia-east" {
  name          = "asia-east"
  ip_cidr_range = "10.10.10.0/28"
  region        = "asia-east1"
  network       = google_compute_network.custom-testing1.id  
}


resource "google_compute_subnetwork" "subnet-asia-south" {
  name          = "asia-south"
  ip_cidr_range = "10.0.10.0/24"
  region        = "asia-south1"
  network       = google_compute_network.custom-testing1.id  
}

resource "google_compute_network" "custom-testing1" {
  name                    = "arb-vpc"
  auto_create_subnetworks = false
}



resource "google_compute_instance" "default" {
  name         = "test"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  tags = ["web"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }



  network_interface {
    network = google_compute_network.custom-testing.id
    subnetwork = google_compute_subnetwork.subnet-us-central.id
  }
}


resource "google_compute_instance" "default1" {
  name         = "test1"
  machine_type = "e2-medium"
  zone         = "asia-east1-a"

  tags = ["web"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }



  network_interface {
    network = google_compute_network.custom-testing1.id
    subnetwork = google_compute_subnetwork.subnet-asia-east.id
  }
}



resource "google_compute_firewall" "default-fire" {
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



resource "google_compute_firewall" "default-fire1" {
  name    = "my-firewall1"
  network = google_compute_network.custom-testing1.name 
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



resource "google_compute_network_peering" "peering1" {
  name         = "my-peering1"
  network      = google_compute_network.custom-testing.self_link
  peer_network = google_compute_network.custom-testing1.self_link
}

resource "google_compute_network_peering" "peering2" {
  name         = "my-peering2"
  network      = google_compute_network.custom-testing1.self_link
  peer_network = google_compute_network.custom-testing.self_link
}