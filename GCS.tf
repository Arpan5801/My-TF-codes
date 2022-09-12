resource "google_storage_bucket" "my-bucket-1-com" {
  name          = "my-bucket-1-com"
  location      = "US"
  storage_class = "STANDARD"
}
