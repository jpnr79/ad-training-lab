packer {
  required_plugins {
    proxmox = {
      version = ">= 1.1.3"
      source  = "github.com/hashicorp/proxmox"
    }
    windows-update = {
      version = ">=0.14.3"
      source  = "github.com/rgl/windows-update"
    }
  }
}

source "proxmox-iso" "traininglab-ws" {
  proxmox_url  = "https://${var.proxmox_node}:8006/api2/json"
  node         = var.proxmox_hostname
  username     = var.proxmox_api_id
  token        = var.proxmox_api_token

  boot_iso {
    type            = "scsi"
    iso_url         = "https://software-static.download.prss.microsoft.com/dbazure/988969d5-f34g-4e03-ac9d-1f9786c66750/19045.2006.220908-0225.22h2_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"
    unmount         = true
    iso_checksum    = "sha256:ef7312733a9f5d7d51cfa04ac497671995674ca5e1058d5164d6028f0938d668"
    iso_download_pve = true
    iso_storage_pool = "local"
  }

  communicator             = "ssh"
  ssh_username             = var.lab_username
  ssh_password             = var.lab_password
  ssh_timeout              = "30m"
  qemu_agent               = true
  cores                    = 6
  cpu_type                 = "host"
  memory                   = 8192
  vm_name                  = "traininglab-ws"
  tags                     = "traininglab_ws"
  template_description     = "TrainingLab Workstation Template"
  insecure_skip_tls_verify = true
  task_timeout             = "30m"

  additional_iso_files {
    cd_files         = ["autounattend.xml"]
    cd_label         = "auto-win10.iso"
    iso_storage_pool = "local"
    unmount          = true
  }

  additional_iso_files {
    device           = "sata0"
    iso_url          = "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/latest-virtio/virtio-win.iso"
    iso_checksum     = "none"
    iso_storage_pool = "local"
    unmount          = true
  }

  network_adapters {
    bridge = var.netbridge
  }

  disks {
    type          = "scsi"
    disk_size     = "50G"
    storage_pool  = var.storage_name
    discard       = true
    io_thread     = true
    format        = "raw"
  }

  scsi_controller = "virtio-scsi-single"
}

build {
  sources = ["sources.proxmox-iso.traininglab-ws"]

  provisioner "windows-update" {
    search_criteria = "AutoSelectOnWebSites=1 and IsInstalled=0"
    update_limit    = 25
  }

  provisioner "file" {
    source      = "ws-sysprep.xml"
    destination = "C:/Users/Public/sysprep.xml"
  }

  provisioner "windows-shell" {
    inline = [
      "c:\\windows\\system32\\sysprep\\sysprep.exe /mode:vm /generalize /oobe /shutdown /unattend:C:\\Users\\Public\\sysprep.xml",
    ]
  }
}
