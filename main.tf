terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.64.0"
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = ">=0.62.0"
    }
  }
}

variable "provider_proxmox" {}
variable "provider_aws" {}
variable "cloud-init" {}

locals {
  datastore = "local"
  data_type = "snippets"

  general = {
    upgrade     = true
    reboot      = true
    run_cmds    = true
    write_files = false
  }

  files = {
    network = [
      {
        path        = "/etc/cloud/cloud.cfg.d/99-custom-networking.cfg"
        permissions = "0644"
        content     = <<-EOT
          network: {config: disabled}
        EOT
      },
    ]
  }

  ubuntu_cmds = [
    "apt install qemu-guest-agent -y",
    "systemctl enable --now qemu-guest-agent",
    "systemctl start qemu-guest-agent",
    "systemctl enable --now ssh",
    "reboot",
  ]

  centos_cmds = [
    "dnf upgrade -y",
    "updatedb",
    "systemctl enable --now cockpit.socket",
    "systemctl start cockpit",
    "systemctl enable --now qemu-guest-agent.service",
    "systemctl start qemu-guest-agent",
    "reboot",
  ]
}

resource "proxmox_virtual_environment_file" "cloud_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = "pve"

  source_raw {
    data = templatefile("${path.module}/templates/cloud.tftpl", {
      UPGRADE     = local.general.upgrade
      REBOOT      = local.general.reboot
      TIMEZONE    = var.cloud-init.general.timezone
      WRITE_FILES = local.general.write_files
      RUN_CMDS    = local.general.run_cmds

      WRITE_INSTRUCTIONS = concat(local.files.network, var.cloud-init.files)
      CMDS               = local.centos_cmds
    })

    file_name = var.cloud-init.general.filename
  }
}

output "id" {
  value = proxmox_virtual_environment_file.cloud_config.id
}


