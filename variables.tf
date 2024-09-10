######### PROVIDER CONFIG ##################################################################################
variable "provider_aws" {
  description = "hashicorp/aws provider configuration variables"
  type = object({
    region = optional(string)
  })
  default = {}
}

variable "provider_proxmox" {
  description = "bpg/proxmox provider configuration variables"
  type = object({
    endpoint          = optional(string)
    username          = optional(string)
    agent_socket      = optional(string)
    node              = optional(string)
    default_datastore = optional(string)
  })
  default = {}
}

######### MODULE: BASE/CLOUD-INIT ############################################################################
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
