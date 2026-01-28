variable "vpc_config" {
  description = "Configuration for the VPC. The attribute 'cidr_block' is required."
  type = object({
    cidr_block  = string
    vpc_name    = optional(string, null)
    description = optional(string, "VPC for large language model application security system")
  })
}

variable "vswitch_config" {
  description = "Configuration for the VSwitch. The attributes 'cidr_block' and 'zone_id' are required."
  type = object({
    cidr_block   = string
    zone_id      = string
    vswitch_name = optional(string, null)
    description  = optional(string, "VSwitch for large language model application security system")
  })
}

variable "security_group_config" {
  description = "Configuration for the security group."
  type = object({
    security_group_name = optional(string, null)
    description         = optional(string, "Security group for large language model application")
    security_group_type = optional(string, "normal")
  })
  default = {}
}

variable "security_group_rules_config" {
  description = "Configuration for security group rules. Use for_each to create multiple rules."
  type = map(object({
    type        = optional(string, "ingress")
    ip_protocol = optional(string, "tcp")
    policy      = optional(string, "accept")
    port_range  = string
    priority    = optional(number, 1)
    cidr_ip     = optional(string, "0.0.0.0/0")
    description = optional(string, "Allow traffic")
  }))
  default = {
    http = {
      port_range  = "80/80"
      description = "Allow HTTP traffic"
    }
    https = {
      port_range  = "443/443"
      description = "Allow HTTPS traffic"
    }
  }
}

variable "ram_user_config" {
  description = "Configuration for the RAM user."
  type = object({
    name         = optional(string, null)
    display_name = optional(string, "Large Language Model Security User")
    mobile       = optional(string, null)
    email        = optional(string, null)
    comments     = optional(string, "RAM user for large language model application security system")
  })
  default = {}
}

variable "ram_access_key_config" {
  description = "Configuration for the RAM access key."
  type = object({
    status = optional(string, "Active")
  })
  default   = {}
  sensitive = true
}

variable "ram_policy_attachments_config" {
  description = "Configuration for RAM user policy attachments. Use for_each to attach multiple policies."
  type = list(object({
    policy_type = optional(string, "System")
    policy_name = string
  }))
  default = [
    {
      policy_name = "AliyunYundunGreenWebFullAccess"
    }
  ]
}

variable "ecs_instances_config" {
  description = "Configuration for ECS instances. Use for_each to create multiple instances."
  type = list(object({
    instance_name              = optional(string, null)
    image_id                   = string
    instance_type              = string
    system_disk_category       = string
    system_disk_size           = optional(number, 40)
    password                   = optional(string, null)
    internet_max_bandwidth_out = optional(number, 5)
    availability_zone          = optional(string, null)
    instance_charge_type       = optional(string, "PostPaid")
    description                = optional(string, "ECS instance for large language model application security system")
  }))
  default = [{
    instance_name              = null
    image_id                   = null
    instance_type              = null
    system_disk_category       = null
    system_disk_size           = 40
    password                   = null
    internet_max_bandwidth_out = 5
    availability_zone          = null
    instance_charge_type       = "PostPaid"
    description                = "ECS instance for large language model application security system"
  }]
}

variable "ecs_command_config" {
  description = "Configuration for the ECS command."
  type = object({
    name        = optional(string, null)
    description = optional(string, "Install security tools for large language model application")
    type        = optional(string, "RunShellScript")
    working_dir = optional(string, "/root")
    timeout     = optional(number, 3600)
  })
  default = {}
}

variable "ecs_invocation_config" {
  description = "Configuration for the ECS command invocation."
  type = object({
    username       = optional(string, "root")
    timeout_create = optional(string, "15m")
  })
  default = {}
}

variable "custom_installation_script" {
  description = "Custom installation script for security tools. If not provided, the default script will be used."
  type        = string
  default     = null
  sensitive   = true
}

variable "bailian_api_key" {
  description = "The API key for Bailian (DashScope) service. Required for accessing large language model services."
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.bailian_api_key) > 0
    error_message = "The bailian_api_key cannot be empty."
  }
}

