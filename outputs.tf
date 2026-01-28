# VPC outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = alicloud_vpc.vpc.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = alicloud_vpc.vpc.cidr_block
}

output "vpc_name" {
  description = "The name of the VPC"
  value       = alicloud_vpc.vpc.vpc_name
}

# VSwitch outputs
output "vswitch_id" {
  description = "The ID of the VSwitch"
  value       = alicloud_vswitch.vswitch.id
}

output "vswitch_cidr_block" {
  description = "The CIDR block of the VSwitch"
  value       = alicloud_vswitch.vswitch.cidr_block
}

output "vswitch_zone_id" {
  description = "The availability zone of the VSwitch"
  value       = alicloud_vswitch.vswitch.zone_id
}

# Security Group outputs
output "security_group_id" {
  description = "The ID of the security group"
  value       = alicloud_security_group.security_group.id
}

output "security_group_name" {
  description = "The name of the security group"
  value       = alicloud_security_group.security_group.security_group_name
}


# RAM User outputs
output "ram_user_name" {
  description = "The name of the RAM user"
  value       = alicloud_ram_user.ram_user.name
}

output "ram_access_key_id" {
  description = "The access key ID of the RAM user"
  value       = alicloud_ram_access_key.ram_access_key.id
  sensitive   = true
}

output "ram_access_key_secret" {
  description = "The access key secret of the RAM user"
  value       = alicloud_ram_access_key.ram_access_key.secret
  sensitive   = true
}


# ECS Instances outputs
output "ecs_instance_ids" {
  description = "The IDs of the ECS instances"
  value       = { for k, v in alicloud_instance.ecs_instances : k => v.id }
}

output "all_ecs_instance_ids" {
  description = "All ECS instance IDs as a list"
  value       = [for instance in alicloud_instance.ecs_instances : instance.id]
}

output "ecs_instance_names" {
  description = "The names of the ECS instances"
  value       = { for k, v in alicloud_instance.ecs_instances : k => v.instance_name }
}

output "ecs_instance_public_ips" {
  description = "The public IP addresses of the ECS instances"
  value       = { for k, v in alicloud_instance.ecs_instances : k => v.public_ip }
}

output "ecs_instance_private_ips" {
  description = "The private IP addresses of the ECS instances"
  value       = { for k, v in alicloud_instance.ecs_instances : k => v.primary_ip_address }
}

# Web URL outputs
output "web_urls" {
  description = "The web access URLs of the large language model applications"
  value       = { for k, v in alicloud_instance.ecs_instances : k => v.public_ip != "" ? format("http://%s", v.public_ip) : format("http://%s", v.primary_ip_address) }
}

# Primary instance outputs for backward compatibility
output "instance_id" {
  description = "The ID of the primary ECS instance"
  value       = length(values(alicloud_instance.ecs_instances)) > 0 ? values(alicloud_instance.ecs_instances)[0].id : null
}

output "instance_name" {
  description = "The name of the primary ECS instance"
  value       = length(values(alicloud_instance.ecs_instances)) > 0 ? values(alicloud_instance.ecs_instances)[0].instance_name : null
}

output "instance_public_ip" {
  description = "The public IP address of the primary ECS instance"
  value       = length(values(alicloud_instance.ecs_instances)) > 0 ? values(alicloud_instance.ecs_instances)[0].public_ip : null
}

output "instance_private_ip" {
  description = "The private IP address of the primary ECS instance"
  value       = length(values(alicloud_instance.ecs_instances)) > 0 ? values(alicloud_instance.ecs_instances)[0].primary_ip_address : null
}

output "web_url" {
  description = "The web access URL of the primary large language model application"
  value = length(values(alicloud_instance.ecs_instances)) > 0 ? (
    values(alicloud_instance.ecs_instances)[0].public_ip != "" ?
    format("http://%s", values(alicloud_instance.ecs_instances)[0].public_ip) :
    format("http://%s", values(alicloud_instance.ecs_instances)[0].primary_ip_address)
  ) : null
}

# ECS Command outputs
output "ecs_command_id" {
  description = "The ID of the ECS command"
  value       = alicloud_ecs_command.install_command.id
}

output "ecs_invocation_ids" {
  description = "The IDs of the ECS command invocations"
  value       = { for k, v in alicloud_ecs_invocation.install_invocations : k => v.id }
}

output "ecs_invocation_statuses" {
  description = "The statuses of the ECS command invocations"
  value       = { for k, v in alicloud_ecs_invocation.install_invocations : k => v.status }
}

# Backward compatibility for single invocation
output "ecs_invocation_id" {
  description = "The ID of the primary ECS command invocation"
  value       = length(values(alicloud_ecs_invocation.install_invocations)) > 0 ? values(alicloud_ecs_invocation.install_invocations)[0].id : null
}

output "ecs_invocation_status" {
  description = "The status of the primary ECS command invocation"
  value       = length(values(alicloud_ecs_invocation.install_invocations)) > 0 ? values(alicloud_ecs_invocation.install_invocations)[0].status : null
}
