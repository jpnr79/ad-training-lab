
variable "pve_node" {
    default = "pve"
    description = "proxmox-pve hostname"
}

variable "pve_node_ip" {
    default = "10.0.253"
    description = "proxmox-pve ip"
}

variable "win_password" {
    description = "windows password defined in packer template"
    default = "ProvisionPassword."
}

variable "win_user" {
    description = "deafult windows localadmin"
    default = "provision"
}

variable "tokenid" {
    # assigned in terraform.tfvars
    description = "terraform-prov proxmox token id"
}

variable "tokenkey" {
    # assigned in terraform.tfvars
    description = "terraform-prov secret key token"
}

variable "storage_name" {
    default = "local"
    description = "proxmox storage name"
}

variable "netbridge" {
  default = "vmbr1"
  description = "network card used to deploy the lab - can be different from packer template!"
}
