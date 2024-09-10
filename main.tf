locals {
  data_type = "snippets"
  defaults = {
    ubuntu = [
      "apt install qemu-guest-agent -y",
      "systemctl enable --now qemu-guest-agent",
      "systemctl start qemu-guest-agent",
      "systemctl enable --now ssh",
      "reboot",
    ]
    centos = [
      "dnf upgrade -y",
      "updatedb",
      "systemctl enable --now cockpit.socket",
      "systemctl start cockpit",
      "systemctl enable --now qemu-guest-agent.service",
      "systemctl start qemu-guest-agent",
      "reboot",
    ]
  }
}

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


resource "proxmox_virtual_environment_file" "cloud_config" {
  content_type = "snippets"
  datastore_id = var.cloud-init.datastore
  node_name    = "pve"

  source_raw {
    data = templatefile("${path.module}/templates/cloud.tftpl", {
      UPGRADE     = var.cloud-init.general.upgrade
      REBOOT      = var.cloud-init.general.reboot
      TIMEZONE    = var.cloud-init.general.timezone
      WRITE_FILES = var.cloud-init.files.enable
      RUN_CMDS    = var.cloud-init.commands.enable

      WRITE_INSTRUCTIONS = var.cloud-init.files.enable ? var.cloud-init.files.spec : []
      CMDS               = var.cloud-init.commands.enable ? (var.cloud-init.commands.use_default ? local.defaults[var.cloud-init.general.target_os] : var.cloud-init.commands.cmds_override) : []
    })

    file_name = var.cloud-init.general.filename
  }
}

output "id" {
  value = proxmox_virtual_environment_file.cloud_config.id
}


