resource "google_compute_instance" "jenkins" {
  count        = length(local.vms)
  project      = var.project_name
  name         = local.vms[count.index].name
  machine_type = local.vms[count.index].machine_type
  zone         = local.vms[count.index].zone

  tags   = local.vms[count.index].tags
  labels = local.vms[count.index].labels

  boot_disk {
    initialize_params {
      image = local.vms[count.index].image
      size  = local.vms[count.index].boot_disk_size
    }
  }

  network_interface {
    network = "default"

    dynamic "access_config" {
      for_each = local.vms[count.index].public_ip == true ? [1] : []
      content {}
    }
  }

  metadata_startup_script = templatefile("startup.tmpl",
    {
      jenkins_version       = var.jenkins_version
      jenkins_external_port = var.jenkins_external_port
      jenkins_project       = var.project_name
  })

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_pub_key_file)}"
  }
}