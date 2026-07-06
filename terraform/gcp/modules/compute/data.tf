data "google_compute_disk" "jenkins" {
  name    = var.extra_disk_name
  project = var.project_name
  zone    = "${var.region}-b"
}