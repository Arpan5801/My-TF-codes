terraform {
  backend "gcs" {
    bucket      = "tf-backend-demo"
    prefix      = "network-tfsate"
  }
}