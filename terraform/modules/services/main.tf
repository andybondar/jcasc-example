resource "google_project_service" "main" {
  count   = length(var.services)
  project = var.project_name
  service = var.services[count.index]

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = true
}