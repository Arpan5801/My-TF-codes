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
