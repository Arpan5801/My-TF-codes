resource "google_compute_subnetwork" "subnet-us-central" {
  name          = "us-central"
  ip_cidr_range = "10.10.0.0/22"
  region        = "us-central1"
  network       = google_compute_network.custom-testing1.id  
}

resource "google_compute_network" "custom-testing1" {
  name                    = "anb-vpc"
  routing_mode            = "GLOBAL"
  auto_create_subnetworks = false
}


resource "google_compute_subnetwork" "subnet-asia-east" {
  name          = "asia-east"
  ip_cidr_range = "100.10.0.0/28"
  region        = "asia-east1"
  network       = google_compute_network.custom-testing2.id  
}

resource "google_compute_network" "custom-testing2" {
  name                    = "arb-vpc"
  routing_mode            = "GLOBAL"
  auto_create_subnetworks = false
}


resource "google_compute_ha_vpn_gateway" "ha_gateway1" {
  name    = "my-onprem1"
  network = google_compute_network.custom-testing1.id
  region  = "us-central1"
}


resource "google_compute_ha_vpn_gateway" "ha_gateway2" {
  name    = "my-onprem2"
  network = google_compute_network.custom-testing2.id
  region  = "us-central1"
}



resource "google_compute_router" "router1" {
  name     = "ha-router1"
  region   = "us-central1"
  network  = google_compute_network.custom-testing1.name
  bgp {
    asn = 64512
  }
}


resource "google_compute_router" "router2" {
  name     = "ha-router2"
  region   = "us-central1"
  network  = google_compute_network.custom-testing2.name
  bgp {
    asn = 64513
  }
}


resource "google_compute_vpn_tunnel" "tunnel1" {
  name                  = "ha-tunnel1"
  region                = "us-central1"
  vpn_gateway           = google_compute_ha_vpn_gateway.ha_gateway1.id
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.ha_gateway2.id
  shared_secret         = "abc"
  router                = google_compute_router.router1.id
  ike_version           = "2"
  vpn_gateway_interface = 0
}

resource "google_compute_vpn_tunnel" "tunnel2" {
  name                  = "ha-tunnel2"
  region                = "us-central1"
  vpn_gateway           = google_compute_ha_vpn_gateway.ha_gateway1.id
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.ha_gateway2.id
  shared_secret         = "abc"
  router                = google_compute_router.router1.id
  ike_version           = "2"
  vpn_gateway_interface = 1
}

resource "google_compute_vpn_tunnel" "tunnel3" {
  name                  = "ha-tunnel3"
  region                = "us-central1"
  vpn_gateway           = google_compute_ha_vpn_gateway.ha_gateway2.id
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.ha_gateway1.id
  shared_secret         = "abc"
  router                = google_compute_router.router2.id
  ike_version           = "2"
  vpn_gateway_interface = 0
}

resource "google_compute_vpn_tunnel" "tunnel4" {
  name                  = "ha-tunnel4"
  region                = "us-central1"
  vpn_gateway           = google_compute_ha_vpn_gateway.ha_gateway2.id
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.ha_gateway1.id
  shared_secret         = "abc"
  router                = google_compute_router.router2.id
  ike_version           = "2"
  vpn_gateway_interface = 1
}


resource "google_compute_router_interface" "router1_interface1" {
  name       = "my-router1-interface1"
  router     = google_compute_router.router1.name
  region     = "us-central1"
  ip_range   = "169.254.0.1/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel1.name
}

resource "google_compute_router_peer" "router1_peer1" {
  name                      = "my-router1-peer1"
  router                    = google_compute_router.router1.name
  region                    = "us-central1"
  peer_ip_address           = "169.254.0.2"
  peer_asn                  = 64513
  interface                 = google_compute_router_interface.router1_interface1.name
}


resource "google_compute_router_interface" "router1_interface2" {
  name       = "my-router1-interface2"
  router     = google_compute_router.router1.name
  region     = "us-central1"
  ip_range   = "169.254.1.2/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel2.name
}

resource "google_compute_router_peer" "router1_peer2" {
  name                      = "my-router1-peer2"
  router                    = google_compute_router.router1.name
  region                    = "us-central1"
  peer_ip_address           = "169.254.1.1"
  peer_asn                  = 64513
  interface                 = google_compute_router_interface.router1_interface2.name
}


resource "google_compute_router_interface" "router2_interface1" {
  name       = "my-router2-interface1"
  router     = google_compute_router.router2.name
  region     = "us-central1"
  ip_range   = "169.254.0.2/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel3.name
}

resource "google_compute_router_peer" "router2_peer1" {
  name                      = "my-router2-peer1"
  router                    = google_compute_router.router2.name
  region                    = "us-central1"
  peer_ip_address           = "169.254.0.1"
  peer_asn                  = 64512
  interface                 = google_compute_router_interface.router2_interface1.name
}

resource "google_compute_router_interface" "router2_interface2" {
  name       = "my-router2-interface2"
  router     = google_compute_router.router2.name
  region     = "us-central1"
  ip_range   = "169.254.1.1/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel4.name
}

resource "google_compute_router_peer" "router2_peer2" {
  name                      = "my-router2-peer2"
  router                    = google_compute_router.router2.name
  region                    = "us-central1"
  peer_ip_address           = "169.254.1.2"
  peer_asn                  = 64512
  interface                 = google_compute_router_interface.router2_interface2.name
}


resource "google_compute_instance" "default1" {
  name         = "test1"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }



  network_interface {
    network = google_compute_network.custom-testing1.id
    subnetwork = google_compute_subnetwork.subnet-us-central.id
  

  access_config {
      // Ephemeral public IP
    }
  }
}



resource "google_compute_instance" "default2" {
  name         = "test2"
  machine_type = "e2-medium"
  zone         = "asia-east1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }



  network_interface {
    network = google_compute_network.custom-testing2.id
    subnetwork = google_compute_subnetwork.subnet-asia-east.id
  

  access_config {
      // Ephemeral public IP
    }
  }
}


resource "google_compute_firewall" "firewall1" {
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
}


resource "google_compute_firewall" "firewall2" {
  name    = "my-firewall2"
  network = google_compute_network.custom-testing2.name 
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