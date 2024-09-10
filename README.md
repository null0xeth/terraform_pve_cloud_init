<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.64.0 |
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | >=0.62.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_proxmox"></a> [proxmox](#provider\_proxmox) | >=0.62.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [proxmox_virtual_environment_file.cloud_config](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_file) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud-init"></a> [cloud-init](#input\_cloud-init) | Configuration variables used to create the cloud-init.yml file | <pre>object({<br>    datastore = optional(string, "local")<br><br>    general = optional(object({<br>      target_os = optional(string, "centos")<br>      filename  = optional(string, "cloud-init.yaml")<br>      timezone  = optional(string, "Your/Tz")<br>      upgrade   = optional(bool, true)<br>      reboot    = optional(bool, true)<br>    }))<br><br>    network = optional(object({<br>      include  = optional(bool)<br>      networks = optional(number)<br>      dhcp4    = optional(bool)<br>    }))<br><br>    files = optional(object({<br>      enable = optional(bool, true)<br>      spec = optional(list(object({<br>        path        = optional(string)<br>        permissions = optional(string)<br>        content     = optional(any)<br>      })))<br>    }))<br><br>    commands = optional(object({<br>      enable        = optional(bool, true)<br>      use_default   = optional(bool, true)<br>      cmds_override = optional(list(string))<br>    }))<br>  })</pre> | n/a | yes |
| <a name="input_provider_aws"></a> [provider\_aws](#input\_provider\_aws) | hashicorp/aws provider configuration variables | <pre>object({<br>    region = optional(string)<br>  })</pre> | `{}` | no |
| <a name="input_provider_proxmox"></a> [provider\_proxmox](#input\_provider\_proxmox) | bpg/proxmox provider configuration variables | <pre>object({<br>    endpoint          = optional(string)<br>    username          = optional(string)<br>    agent_socket      = optional(string)<br>    node              = optional(string)<br>    default_datastore = optional(string)<br>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
<!-- END_TF_DOCS -->