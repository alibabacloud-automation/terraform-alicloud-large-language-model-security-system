
provider "alicloud" {
  region = "cn-zhangjiakou"
}

# Data source to get available zones
data "alicloud_zones" "available" {
  available_resource_creation = "VSwitch"
}

# Data source to get available ECS instance types
data "alicloud_instance_types" "available" {
  availability_zone    = data.alicloud_zones.available.zones[0].id
  cpu_core_count       = 2
  memory_size          = 8
  instance_type_family = "ecs.g9i"
}

# Data source to get available images
data "alicloud_images" "ubuntu" {
  name_regex  = "^ubuntu_20_04_x64.*"
  most_recent = true
  owners      = "system"
}

module "large_model_security_system" {
  source = "../../"

  # VPC configuration
  vpc_config = {
    cidr_block  = "192.168.0.0/16"
    vpc_name    = "large-model-security-vpc"
    description = "VPC for large model application security system"
  }

  # VSwitch configuration
  vswitch_config = {
    cidr_block   = "192.168.1.0/24"
    zone_id      = data.alicloud_zones.available.zones[0].id
    vswitch_name = "large-model-security-vswitch"
    description  = "VSwitch for large model application security system"
  }

  # Security group configuration
  security_group_config = {
    security_group_name = "large-model-security-sg"
    description         = "Security group for large model application"
    security_group_type = "normal"
  }

  # Security group rules configuration - using for_each for multiple rules
  security_group_rules_config = {
    http = {
      port_range  = "80/80"
      description = "Allow HTTP traffic"
      cidr_ip     = "192.168.1.0/24"
    }
    https = {
      port_range  = "443/443"
      description = "Allow HTTPS traffic"
      cidr_ip     = "192.168.1.0/24"
    }
    ssh = {
      port_range  = "22/22"
      description = "Allow SSH access"
      cidr_ip     = "192.168.1.0/24"
    }
    custom_app = {
      port_range  = "8080/8080"
      description = "Allow custom application traffic"
      cidr_ip     = "192.168.1.0/24"
    }
  }

  # RAM user configuration
  ram_user_config = {
    name         = "large-model-security-user"
    display_name = "Large Model Security User"
    email        = "admin@example.com"
    comments     = "RAM user for large model application security system"
  }

  # RAM access key configuration
  ram_access_key_config = {
    status = "Active"
  }

  # RAM policy attachments configuration - using for_each for multiple policies
  ram_policy_attachments_config = [
    {
      policy_name = "AliyunYundunGreenWebFullAccess"
    },
    {
      policy_name = "AliyunECSFullAccess"
    }
  ]

  # ECS instances configuration - using for_each for multiple instances
  ecs_instances_config = [
    {
      instance_name              = "primary"
      image_id                   = data.alicloud_images.ubuntu.images[0].id
      instance_type              = data.alicloud_instance_types.available.instance_types[0].id
      system_disk_category       = "cloud_essd"
      system_disk_size           = 40
      password                   = var.ecs_instance_password
      internet_max_bandwidth_out = 5
      availability_zone          = data.alicloud_zones.available.zones[0].id
      instance_charge_type       = "PostPaid"
      description                = "ECS instance for large model application security system"
    },
    {
      instance_name              = "backup"
      image_id                   = data.alicloud_images.ubuntu.images[0].id
      instance_type              = data.alicloud_instance_types.available.instance_types[0].id
      system_disk_category       = "cloud_essd"
      system_disk_size           = 40
      password                   = var.ecs_instance_password
      internet_max_bandwidth_out = 5
      availability_zone          = data.alicloud_zones.available.zones[0].id
      instance_charge_type       = "PostPaid"
      description                = "ECS instance for large model application security system"
    }
  ]

  # ECS command configuration
  ecs_command_config = {
    name        = "large-model-security-install-cmd"
    description = "Install security tools for large model application"
    type        = "RunShellScript"
    working_dir = "/root"
    timeout     = 3600
  }

  # ECS invocation configuration
  ecs_invocation_config = {
    username       = "root"
    timeout_create = "15m"
  }

  # Custom installation script (optional)
  custom_installation_script = var.custom_installation_script

  # Bailian API key
  bailian_api_key = var.bailian_api_key
}