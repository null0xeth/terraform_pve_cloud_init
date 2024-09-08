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
| <a name="input_cloud-init"></a> [cloud-init](#input\_cloud-init) | n/a | `any` | n/a | yes |
| <a name="input_provider_aws"></a> [provider\_aws](#input\_provider\_aws) | n/a | `any` | n/a | yes |
| <a name="input_provider_proxmox"></a> [provider\_proxmox](#input\_provider\_proxmox) | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
<!-- END_TF_DOCS -->