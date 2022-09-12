resource "google_compute_subnetwork" "subnet-asia-south" {
  name          = "asia-south"
  ip_cidr_range = "10.10.0.0/22"
  region        = "asia-south1"
  network       = google_compute_network.custom-test.id  
}


resource "google_compute_subnetwork" "subnet-asia-southeast1" {
  name          = "south-west"
  ip_cidr_range = "10.1.0.0/18"
  region        = "asia-southeast1"
  network       = google_compute_network.custom-test.id  
}

resource "google_compute_network" "custom-test" {
  name                    = "pnb-vpc"
  auto_create_subnetworks = false
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


resource "google_compute_instance" "default2" {
  name         = "test1"
  machine_type = "e2-medium"
  zone         = "asia-south1-b"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }



  network_interface {
    network = google_compute_network.custom-test.id
    subnetwork = google_compute_subnetwork.subnet-asia-south.id


  access_config {
      // Ephemeral public IP
    }
  }
}
  



resource "google_compute_instance" "default3" {
  name         = "test2"
  machine_type = "e2-medium"
  zone         = "asia-southeast1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }



  network_interface {
    network = google_compute_network.custom-test.id
    subnetwork = google_compute_subnetwork.subnet-asia-southeast1.id


  access_config {
      // Ephemeral public IP
    }
  }
}