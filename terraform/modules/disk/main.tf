resource "google_compute_disk" "main" {
  name    = var.extra_disk_name
  project = var.project_name
  type    = var.extra_disk_type
  zone    = "${var.region}-b"
  size    = var.extra_disk_size
}