Alibaba Cloud Large Language Model Application Security System Terraform Module

# terraform-alicloud-large-language-model-security-system

English | [简体中文](https://github.com/alibabacloud-automation/terraform-alicloud-large-language-model-security-system/blob/main/README-CN.md)

Terraform module which creates a comprehensive security system for large language model applications on Alibaba Cloud. This module provides a complete infrastructure setup including VPC network isolation, ECS compute resources, RAM identity management, and automated security tools deployment to protect large language model applications from various security threats. The module is designed to address the growing security challenges in [large model application security systems](https://www.aliyun.com/solution/tech-solution/build-large-model-application-security-system) by providing enterprise-grade security controls and monitoring capabilities.

## Usage

This module creates a secure environment for deploying large language model applications with proper network isolation, access control, and security monitoring capabilities. It supports multiple ECS instances deployment using for_each pattern and configurable security rules for enhanced flexibility.

```terraform
data "alicloud_zones" "available" {
  available_resource_creation = "VSwitch"
}

data "alicloud_instance_types" "available" {
  availability_zone    = data.alicloud_zones.available.zones[0].id
  cpu_core_count       = 2
  memory_size          = 4
  instance_type_family = "ecs.g6"
}

data "alicloud_images" "ubuntu" {
  name_regex  = "^ubuntu_20_04_x64.*"
  most_recent = true
  owners      = "system"
}

module "large_language_model_security" {
  source = "alibabacloud-automation/large-language-model-security-system/alicloud"

  # VPC configuration
  vpc_config = {
    cidr_block  = "192.168.0.0/16"
    vpc_name    = "large-language-model-security-vpc"
    description = "VPC for large language model application security system"
  }

  # VSwitch configuration
  vswitch_config = {
    cidr_block   = "192.168.1.0/24"
    zone_id      = data.alicloud_zones.available.zones[0].id
    vswitch_name = "large-language-model-security-vswitch"
  }

  # ECS instances configuration - supports multiple instances using for_each
  ecs_instances_config = {
    primary = {
      instance_name = "large-language-model-security-primary"
    }
    backup = {
      instance_name = "large-language-model-security-backup"
    }
  }

  # ECS instance configuration
  instance_config = {
    image_id                   = data.alicloud_images.ubuntu.images[0].id
    instance_type              = data.alicloud_instance_types.available.instance_types[0].id
    system_disk_category       = "cloud_essd"
    system_disk_size           = 40
    password                   = "YourSecurePassword123!"
    internet_max_bandwidth_out = 5
    availability_zone          = data.alicloud_zones.available.zones[0].id
  }

  # Bailian API key for large language model services
  bailian_api_key = "your-bailian-api-key"
}
```

## Examples

* [Complete Example](https://github.com/alibabacloud-automation/terraform-alicloud-large-language-model-security-system/tree/main/examples/complete)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | >= 1.212.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alicloud"></a> [alicloud](#provider\_alicloud) | >= 1.212.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [alicloud_ecs_command.install_command](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ecs_command) | resource |
| [alicloud_ecs_invocation.install_invocations](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ecs_invocation) | resource |
| [alicloud_instance.ecs_instances](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/instance) | resource |
| [alicloud_ram_access_key.ram_access_key](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ram_access_key) | resource |
| [alicloud_ram_user.ram_user](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ram_user) | resource |
| [alicloud_ram_user_policy_attachment.policy_attachments](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ram_user_policy_attachment) | resource |
| [alicloud_security_group.security_group](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/security_group) | resource |
| [alicloud_security_group_rule.security_rules](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/security_group_rule) | resource |
| [alicloud_vpc.vpc](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/vpc) | resource |
| [alicloud_vswitch.vswitch](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/vswitch) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bailian_api_key"></a> [bailian\_api\_key](#input\_bailian\_api\_key) | The API key for Bailian (DashScope) service. Required for accessing large language model services. | `string` | n/a | yes |
| <a name="input_custom_installation_script"></a> [custom\_installation\_script](#input\_custom\_installation\_script) | Custom installation script for security tools. If not provided, the default script will be used. | `string` | `null` | no |
| <a name="input_ecs_command_config"></a> [ecs\_command\_config](#input\_ecs\_command\_config) | Configuration for the ECS command. | <pre>object({<br>    name        = optional(string, null)<br>    description = optional(string, "Install security tools for large language model application")<br>    type        = optional(string, "RunShellScript")<br>    working_dir = optional(string, "/root")<br>    timeout     = optional(number, 3600)<br>  })</pre> | `{}` | no |
| <a name="input_ecs_instances_config"></a> [ecs\_instances\_config](#input\_ecs\_instances\_config) | Configuration for ECS instances. Use for\_each to create multiple instances. | <pre>list(object({<br>    instance_name              = optional(string, null)<br>    image_id                   = string<br>    instance_type              = string<br>    system_disk_category       = string<br>    system_disk_size           = optional(number, 40)<br>    password                   = optional(string, null)<br>    internet_max_bandwidth_out = optional(number, 5)<br>    availability_zone          = optional(string, null)<br>    instance_charge_type       = optional(string, "PostPaid")<br>    description                = optional(string, "ECS instance for large language model application security system")<br>  }))</pre> | <pre>[<br>  {<br>    "availability_zone": null,<br>    "description": "ECS instance for large language model application security system",<br>    "image_id": null,<br>    "instance_charge_type": "PostPaid",<br>    "instance_name": null,<br>    "instance_type": null,<br>    "internet_max_bandwidth_out": 5,<br>    "password": null,<br>    "system_disk_category": null,<br>    "system_disk_size": 40<br>  }<br>]</pre> | no |
| <a name="input_ecs_invocation_config"></a> [ecs\_invocation\_config](#input\_ecs\_invocation\_config) | Configuration for the ECS command invocation. | <pre>object({<br>    username       = optional(string, "root")<br>    timeout_create = optional(string, "15m")<br>  })</pre> | `{}` | no |
| <a name="input_ram_access_key_config"></a> [ram\_access\_key\_config](#input\_ram\_access\_key\_config) | Configuration for the RAM access key. | <pre>object({<br>    status = optional(string, "Active")<br>  })</pre> | `{}` | no |
| <a name="input_ram_policy_attachments_config"></a> [ram\_policy\_attachments\_config](#input\_ram\_policy\_attachments\_config) | Configuration for RAM user policy attachments. Use for\_each to attach multiple policies. | <pre>list(object({<br>    policy_type = optional(string, "System")<br>    policy_name = string<br>  }))</pre> | <pre>[<br>  {<br>    "policy_name": "AliyunYundunGreenWebFullAccess"<br>  }<br>]</pre> | no |
| <a name="input_ram_user_config"></a> [ram\_user\_config](#input\_ram\_user\_config) | Configuration for the RAM user. | <pre>object({<br>    name         = optional(string, null)<br>    display_name = optional(string, "Large Language Model Security User")<br>    mobile       = optional(string, null)<br>    email        = optional(string, null)<br>    comments     = optional(string, "RAM user for large language model application security system")<br>  })</pre> | `{}` | no |
| <a name="input_security_group_config"></a> [security\_group\_config](#input\_security\_group\_config) | Configuration for the security group. | <pre>object({<br>    security_group_name = optional(string, null)<br>    description         = optional(string, "Security group for large language model application")<br>    security_group_type = optional(string, "normal")<br>  })</pre> | `{}` | no |
| <a name="input_security_group_rules_config"></a> [security\_group\_rules\_config](#input\_security\_group\_rules\_config) | Configuration for security group rules. Use for\_each to create multiple rules. | <pre>map(object({<br>    type        = optional(string, "ingress")<br>    ip_protocol = optional(string, "tcp")<br>    policy      = optional(string, "accept")<br>    port_range  = string<br>    priority    = optional(number, 1)<br>    cidr_ip     = optional(string, "0.0.0.0/0")<br>    description = optional(string, "Allow traffic")<br>  }))</pre> | <pre>{<br>  "http": {<br>    "description": "Allow HTTP traffic",<br>    "port_range": "80/80"<br>  },<br>  "https": {<br>    "description": "Allow HTTPS traffic",<br>    "port_range": "443/443"<br>  }<br>}</pre> | no |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | Configuration for the VPC. The attribute 'cidr\_block' is required. | <pre>object({<br>    cidr_block  = string<br>    vpc_name    = optional(string, null)<br>    description = optional(string, "VPC for large language model application security system")<br>  })</pre> | n/a | yes |
| <a name="input_vswitch_config"></a> [vswitch\_config](#input\_vswitch\_config) | Configuration for the VSwitch. The attributes 'cidr\_block' and 'zone\_id' are required. | <pre>object({<br>    cidr_block   = string<br>    zone_id      = string<br>    vswitch_name = optional(string, null)<br>    description  = optional(string, "VSwitch for large language model application security system")<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_all_ecs_instance_ids"></a> [all\_ecs\_instance\_ids](#output\_all\_ecs\_instance\_ids) | All ECS instance IDs as a list |
| <a name="output_ecs_command_id"></a> [ecs\_command\_id](#output\_ecs\_command\_id) | The ID of the ECS command |
| <a name="output_ecs_instance_ids"></a> [ecs\_instance\_ids](#output\_ecs\_instance\_ids) | The IDs of the ECS instances |
| <a name="output_ecs_instance_names"></a> [ecs\_instance\_names](#output\_ecs\_instance\_names) | The names of the ECS instances |
| <a name="output_ecs_instance_private_ips"></a> [ecs\_instance\_private\_ips](#output\_ecs\_instance\_private\_ips) | The private IP addresses of the ECS instances |
| <a name="output_ecs_instance_public_ips"></a> [ecs\_instance\_public\_ips](#output\_ecs\_instance\_public\_ips) | The public IP addresses of the ECS instances |
| <a name="output_ecs_invocation_id"></a> [ecs\_invocation\_id](#output\_ecs\_invocation\_id) | The ID of the primary ECS command invocation |
| <a name="output_ecs_invocation_ids"></a> [ecs\_invocation\_ids](#output\_ecs\_invocation\_ids) | The IDs of the ECS command invocations |
| <a name="output_ecs_invocation_status"></a> [ecs\_invocation\_status](#output\_ecs\_invocation\_status) | The status of the primary ECS command invocation |
| <a name="output_ecs_invocation_statuses"></a> [ecs\_invocation\_statuses](#output\_ecs\_invocation\_statuses) | The statuses of the ECS command invocations |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | The ID of the primary ECS instance |
| <a name="output_instance_name"></a> [instance\_name](#output\_instance\_name) | The name of the primary ECS instance |
| <a name="output_instance_private_ip"></a> [instance\_private\_ip](#output\_instance\_private\_ip) | The private IP address of the primary ECS instance |
| <a name="output_instance_public_ip"></a> [instance\_public\_ip](#output\_instance\_public\_ip) | The public IP address of the primary ECS instance |
| <a name="output_ram_access_key_id"></a> [ram\_access\_key\_id](#output\_ram\_access\_key\_id) | The access key ID of the RAM user |
| <a name="output_ram_access_key_secret"></a> [ram\_access\_key\_secret](#output\_ram\_access\_key\_secret) | The access key secret of the RAM user |
| <a name="output_ram_user_name"></a> [ram\_user\_name](#output\_ram\_user\_name) | The name of the RAM user |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | The ID of the security group |
| <a name="output_security_group_name"></a> [security\_group\_name](#output\_security\_group\_name) | The name of the security group |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | The CIDR block of the VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
| <a name="output_vpc_name"></a> [vpc\_name](#output\_vpc\_name) | The name of the VPC |
| <a name="output_vswitch_cidr_block"></a> [vswitch\_cidr\_block](#output\_vswitch\_cidr\_block) | The CIDR block of the VSwitch |
| <a name="output_vswitch_id"></a> [vswitch\_id](#output\_vswitch\_id) | The ID of the VSwitch |
| <a name="output_vswitch_zone_id"></a> [vswitch\_zone\_id](#output\_vswitch\_zone\_id) | The availability zone of the VSwitch |
| <a name="output_web_url"></a> [web\_url](#output\_web\_url) | The web access URL of the primary large language model application |
| <a name="output_web_urls"></a> [web\_urls](#output\_web\_urls) | The web access URLs of the large language model applications |
<!-- END_TF_DOCS -->

## Submit Issues

If you have any problems when using this module, please opening
a [provider issue](https://github.com/aliyun/terraform-provider-alicloud/issues/new) and let us know.

**Note:** There does not recommend opening an issue on this repo.

## Authors

Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com).

## License

MIT Licensed. See LICENSE for full details.

## Reference

* [Terraform-Provider-Alicloud Github](https://github.com/aliyun/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs)