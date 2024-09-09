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

variable "cloud-init" {
  description = "Configuration variables used to create the cloud-init.yml file"
  type = object({
    datastore = optional(string, "local")

    general = optional(object({
      target_os = optional(string, "centos")
      filename  = optional(string, "cloud-init.yaml")
      timezone  = optional(string, "Your/Tz")
      upgrade   = optional(bool, true)
      reboot    = optional(bool, true)
    }))

    network = optional(object({
      include  = optional(bool)
      networks = optional(number)
      dhcp4    = optional(bool)
    }))

    files = optional(object({
      enable = optional(bool, true)
      spec = optional(list(object({
        path        = optional(string)
        permissions = optional(string)
        content     = optional(any)
      })))
    }))

    commands = optional(object({
      enable        = optional(bool, true)
      use_default   = optional(bool, true)
      cmds_override = optional(list(string))
    }))
  })
}

locals {
  /* datastore = "local" */
  data_type = "snippets"

  # general = {
  #   upgrade     = true
  #   reboot      = true
  #   run_cmds    = true
  #   write_files = false
  # }

  # files = {
  #   network = [
  #     {
  #       path        = "/etc/cloud/cloud.cfg.d/99-custom-networking.cfg"
  #       permissions = "0644"
  #       content     = <<-EOT
  #         network: {config: disabled}
  #       EOT
  #     },
  #   ]
  # }

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


