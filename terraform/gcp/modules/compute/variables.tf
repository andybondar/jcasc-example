variable "jenkins_version" {
  type        = string
  description = "Jenkins Version"
  default     = "jcasc"
}

variable "jenkins_external_port" {
  type        = string
  description = "Jenkins external port"
  default     = "8080"
}

variable "jenkins_admin" {
  type        = string
  description = "Jenkins admin"
}

variable "jenkins_pw" {
  type        = string
  description = "Jenkins password"
}

variable "dns_project_name" {
  type        = string
  description = "DNS Project Name"
}

variable "ssh_user" {
  type        = string
  description = "SSH user's name"
}

variable "ssh_pub_key_file" {
  type        = string
  description = "Server's user SSH public key"
}

variable "vm_properties" {
  type        = any
  description = "Jenkins VM Properties"
  default     = {}
}

variable "firewall_rules" {
  type        = any
  description = "Firewall Rules"
  default     = {}
}