locals {
  env_name  = split("-", var.project_name)[0]
  env_type  = split("-", var.project_name)[1]
  iteration = split("-", var.project_name)[2]

  vms = flatten([
    for vm in var.vm_properties : {
      "name" = format("%s-%s-%s-%s",
        local.env_name,
        vm.short_name,
        local.env_type,
        local.iteration
      )
      "machine_type"   = vm.machine_type
      "zone"           = format("%s-%s", var.region, vm.zone_letter)
      "boot_disk_size" = vm.boot_disk_size
      "image"          = vm.boot_disk_image
      "public_ip"      = vm.public_ip
      "tags"           = vm.tags
      "labels"         = vm.labels
    }
  ])
}