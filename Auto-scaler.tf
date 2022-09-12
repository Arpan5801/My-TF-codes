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
