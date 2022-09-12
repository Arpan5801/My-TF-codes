resource "google_compute_router" "my-router" {
  name    = "my-router"
  region  = google_compute_subnetwork.subnet-us-central.region
  network = google_compute_network.custom-testing.id
}
