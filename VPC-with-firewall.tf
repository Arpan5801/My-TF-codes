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



resource "google_compute_instance" "default1" {
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


resource "google_storage_bucket" "my-bucket-1-com" {
  name          = "my-bucket-1-com"
  location      = "US"
  storage_class = "STANDARD"
}



resource "google_compute_router" "my-router" {
  name    = "my-router"
  region  = google_compute_subnetwork.subnet-us-central.region
  network = google_compute_network.custom-testing.id
}



resource "google_compute_router_nat" "nat" {
  name                               = "my-nat"
  region                             = google_compute_router.my-router.region
  router                             = google_compute_router.my-router.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}


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