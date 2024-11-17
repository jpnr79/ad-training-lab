packer {
  required_plugins {
    proxmox = {
      version = ">= 1.1.3"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

source "proxmox-iso" "traininglab-server" {
  proxmox_url             = "https://${var.proxmox_node}:8006/api2/json"
  node                    = var.proxmox_hostname
  username                = var.proxmox_api_id
  token                   = var.proxmox_api_token
  communicator            = "ssh"
  ssh_username            = var.lab_username
  ssh_password            = var.lab_password
  ssh_timeout             = "30m"
  qemu_agent              = true
  cores                   = 2
  cpu_type                = "host"
  memory                  = 2048
  vm_name                 = "traininglab-server"
  tags                    = "traininglab_server"
  template_description    = "TrainingLab Ubuntu Server Template"
  insecure_skip_tls_verify = true
  task_timeout            = "30m"
  http_directory          = "server"
  scsi_controller         = "virtio-scsi-single"
  boot_wait               = "10s"

  boot_iso {
    type             = "ide"
    iso_url          = "https://releases.ubuntu.com/22.04.5/ubuntu-22.04.5-live-server-amd64.iso"
    unmount          = true
    iso_checksum     = "sha256:9bc6028870aef3f74f4e16b900008179e78b130e6b0b9a140635434a46aa98b0"
    iso_download_pve = true
    iso_storage_pool = "local"
  }

  additional_iso_files {
    cd_files = [
      "./server/meta-data",
      "./server/user-data"
    ]
    cd_label         = "cidata"
    iso_storage_pool = "local"
    unmount          = true
  }

  network_adapters {
    bridge = var.netbridge
  }

  disks {
    disk_size    = "30G"
    storage_pool = var.storage_name
    type         = "scsi"
    discard      = true
    io_thread    = true
    format       = "raw"
  }

  boot_command = [
    "<esc><esc><esc><esc>e<wait>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del><del>",
    "linux /casper/vmlinuz --- autoinstall s=/cidata/<enter><wait>",
    "initrd /casper/initrd<enter><wait>",
    "boot<enter>",
    "<enter><f10><wait>"
  ]
}

build {
  sources = ["sources.proxmox-iso.traininglab-server"]
}
