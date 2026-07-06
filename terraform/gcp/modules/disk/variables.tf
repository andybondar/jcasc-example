variable "extra_disk_type" {
  type        = string
  description = "Extra disk type"
  default     = "pd-ssd"
}

variable "extra_disk_size" {
  description = "Extra disk size"
  default     = 20
}