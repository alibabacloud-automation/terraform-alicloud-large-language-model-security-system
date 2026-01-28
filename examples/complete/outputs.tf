output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.large_model_security_system.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.large_model_security_system.vpc_cidr_block
}

output "vpc_name" {
  description = "The name of the VPC"
  value       = module.large_model_security_system.vpc_name
}

output "vswitch_id" {
  description = "The ID of the VSwitch"
  value       = module.large_model_security_system.vswitch_id
}

output "vswitch_cidr_block" {
  description = "The CIDR block of the VSwitch"
  value       = module.large_model_security_system.vswitch_cidr_block
}

output "vswitch_zone_id" {
  description = "The availability zone of the VSwitch"
  value       = module.large_model_security_system.vswitch_zone_id
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = module.large_model_security_system.security_group_id
}

output "security_group_name" {
  description = "The name of the security group"
  value       = module.large_model_security_system.security_group_name
}

output "all_ecs_instance_ids" {
  description = "All ECS instance IDs as a list"
  value       = module.large_model_security_system.all_ecs_instance_ids
}

output "ecs_instance_ids" {
  description = "The IDs of the ECS instances"
  value       = module.large_model_security_system.ecs_instance_ids
}

output "ecs_instance_names" {
  description = "The names of the ECS instances"
  value       = module.large_model_security_system.ecs_instance_names
}

output "ecs_instance_public_ips" {
  description = "The public IP addresses of the ECS instances"
  value       = module.large_model_security_system.ecs_instance_public_ips
}

output "ecs_instance_private_ips" {
  description = "The private IP addresses of the ECS instances"
  value       = module.large_model_security_system.ecs_instance_private_ips
}

output "web_urls" {
  description = "The web access URLs of the large model applications"
  value       = module.large_model_security_system.web_urls
}

output "ram_user_name" {
  description = "The name of the RAM user"
  value       = module.large_model_security_system.ram_user_name
}

output "ram_access_key_id" {
  description = "The access key ID of the RAM user"
  value       = module.large_model_security_system.ram_access_key_id
  sensitive   = true
}

output "ram_access_key_secret" {
  description = "The access key secret of the RAM user"
  value       = module.large_model_security_system.ram_access_key_secret
  sensitive   = true
}

output "ecs_command_id" {
  description = "The ID of the ECS command"
  value       = module.large_model_security_system.ecs_command_id
}

