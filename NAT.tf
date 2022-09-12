resource "google_compute_router_nat" "nat" {
  name                               = "my-nat"
  region                             = google_compute_router.my-router.region
  router                             = google_compute_router.my-router.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
