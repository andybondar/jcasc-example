variable "region" {
  type        = string
  description = "GCP region, possible values below"
  default     = "us-central1"
  # "asia-east1"
  # "asia-east"
  # "asia-northeast1"
  # "asia-northeast2"
  # "asia-northeast3"
  # "asia-south1"
  # "asia-southeast1"
  # "asia-southeast2"
  # "australia-southeast1"
  # "europe-north1"
  # "europe-west1"
  # "europe-west2"
  # "europe-west3"
  # "europe-west4"
  # "europe-west6"
  # "northamerica-northeast1"
  # "southamerica-east1"
  # "us-central1"
  # "us-east1"
  # "us-east4"
  # "us-west1"
  # "us-west2"
  # "us-west3"
  # "us-west4"
}

variable "project_name" {
  type        = string
  description = "GCP project name"
  # default     = "jcas-lab-01"
}

variable "extra_disk_name" {
  type        = string
  description = "Extra disk name"
  default     = "jenkins-data"
}