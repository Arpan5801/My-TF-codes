FIRST PART:- [Creating VPC with subnetwork along with VM]


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




SECOND PART:- [Creating VPC with subnetwork along with VM,GCS,Router,NAT,Firewall]



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



THIRD PART:- [Creating VPC with subnetwork along with VM,Firewall,Network peering]



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



FOURTH PART:- [Creating VM along with Startup script and Firewall]



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



FIFTH PART:- [Creating VPC with subnetwork along with VPN,Router,Tunnel,VM,Firewall]



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



SIXTH PART:- [Creating IAM and Service account]



data "google_iam_policy" "admin" {
  binding {
    role = "roles/iam.serviceAccountUser"

    members = [
      "user:arpan.das5801@gmail.com",
    ]
  }
}

resource "google_service_account" "sa" {
  account_id   = "my-service-account"
  display_name = "A service account that only Arpan can interact with"
}

resource "google_service_account_iam_policy" "admin-account-iam" {
  service_account_id = google_service_account.sa.name
  policy_data        = data.google_iam_policy.admin.policy_data
}



SEVENTH PART:- [Creating Instance group along with Instance template,Auto scaler,Health check,Load balancer]


# reserved IP address
resource "google_compute_global_address" "default" {
  name = "arpan-static-ip"
}

# forwarding rule
resource "google_compute_global_forwarding_rule" "default" {
  name                  = "arpan-forwarding-rule"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.default.id
  ip_address            = google_compute_global_address.default.id
}

# http proxy
resource "google_compute_target_http_proxy" "default" {
  name     = "arpan-target-http-proxy"
  url_map  = google_compute_url_map.default.id
}

# url map
resource "google_compute_url_map" "default" {
  name            = "arpan-map"
  default_service = google_compute_backend_service.default.id
}

# backend service with custom request and response headers
resource "google_compute_backend_service" "default" {
  name                     = "arpan-backend-service"
  protocol                 = "HTTP"
  port_name                = "http"
  load_balancing_scheme    = "EXTERNAL"
  timeout_sec              = 10
  enable_cdn               = true
  health_checks            = [google_compute_health_check.default.id]
  backend {
    group           = google_compute_instance_group_manager.default.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }
}

# instance template
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

  # install apache and serve a simple web page
  
  metadata = {
    startup-script-url = "gs://my-important-notes-bucket/new.sh"
    }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = "116295551265-compute@developer.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

# health check
resource "google_compute_health_check" "default" {
  name     = "arpan-hc"
  tcp_health_check {
    port = "80"
  }
}

# MIG
resource "google_compute_instance_group_manager" "default" {
  name     = "arpan-igm"
  zone     = "us-central1-a"
  named_port {
    name = "http"
    port = 80
  }
   auto_healing_policies {
   health_check  = google_compute_health_check.default.id 
   initial_delay_sec = 50
  }
  version {
    instance_template = google_compute_instance_template.default.id
    name              = "primary"
  }

  target_pools       = [google_compute_target_pool.default.id]
  base_instance_name = "vm-sample"
}

# allow access from health check ranges
resource "google_compute_firewall" "default" {
  name          = "arpan-fw-allow-hc"
  direction     = "INGRESS"
  network       = "default"
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16", "0.0.0.0/0"]
  allow {
    protocol = "tcp"
     ports    = ["80"]
  }
  target_tags = ["allow-health-check"]
}

resource "google_compute_autoscaler" "default" {

  name   = "arpan-autoscaler"
  zone   = "us-central1-a"
  target = google_compute_instance_group_manager.default.id

  autoscaling_policy {
    max_replicas    = 4
    min_replicas    = 2
    cooldown_period = 60

    cpu_utilization {
      target = 0.7
    }
  }
}

resource "google_compute_target_pool" "default" {
    region = "us-central1"
    name   = "arpan-target-pool"
}







