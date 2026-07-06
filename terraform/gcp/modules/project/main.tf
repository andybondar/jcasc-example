resource "google_project" "main" {
  name            = var.project_name
  project_id      = var.project_name
  billing_account = var.billing_account
}