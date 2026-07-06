data "google_dns_managed_zone" "main" {
  name    = "quagga-org-ua"
  project = var.dns_project_name
}

resource "google_dns_record_set" "jenkins" {
  name    = "jenkins.${data.google_dns_managed_zone.main.dns_name}"
  project = var.dns_project_name
  type    = "A"
  ttl     = 30

  managed_zone = data.google_dns_managed_zone.main.name

  rrdatas = [google_compute_instance.jenkins[0].network_interface[0].access_config[0].nat_ip]
}