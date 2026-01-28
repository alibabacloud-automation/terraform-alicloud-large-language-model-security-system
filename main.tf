locals {
  # Default installation script for security tools
  default_installation_script = <<-EOF
#!/bin/bash

# Set environment variables
cat <<EOT >> ~/.bash_profile
export ROS_DEPLOY=true
export BAILIAN_API_KEY=${var.bailian_api_key}
export ALIBABA_CLOUD_ACCESS_KEY_ID=${alicloud_ram_access_key.ram_access_key.id}
export ALIBABA_CLOUD_ACCESS_KEY_SECRET=${alicloud_ram_access_key.ram_access_key.secret}
EOT

# Source the profile to make variables available
source ~/.bash_profile

# Update system packages
yum update -y

# Install required dependencies
yum install -y curl wget unzip python3 python3-pip

# Download and install security tools for large model applications
echo "Installing security tools for large model application..."

# Create application directory
mkdir -p /opt/large-model-security
cd /opt/large-model-security

# Install AI security monitoring tools
pip3 install dashscope alibabacloud-tea-openapi alibabacloud-green20220302

# Create security monitoring script
cat <<EOT > /opt/large-model-security/security_monitor.py
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import os
import logging
import dashscope
from alibabacloud_green20220302.client import Client as Green20220302Client
from alibabacloud_tea_openapi import models as open_api_models

def setup_logging():
    logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
    return logging.getLogger(__name__)

def main():
    logger = setup_logging()
    logger.info("Large model security monitoring service started")

    # Initialize DashScope API
    dashscope.api_key = os.environ.get('BAILIAN_API_KEY')

    # Initialize Green API client for content moderation
    config = open_api_models.Config(
        access_key_id=os.environ.get('ALIBABA_CLOUD_ACCESS_KEY_ID'),
        access_key_secret=os.environ.get('ALIBABA_CLOUD_ACCESS_KEY_SECRET'),
        endpoint='green.cn-hangzhou.aliyuncs.com'
    )
    green_client = Green20220302Client(config)

    logger.info("Security monitoring initialized successfully")

if __name__ == "__main__":
    main()
EOT

chmod +x /opt/large-model-security/security_monitor.py

# Set up log rotation for security logs
cat <<EOT > /etc/logrotate.d/large-model-security
/var/log/large-model-security/*.log {
    daily
    rotate 30
    compress
    delaycompress
    missingok
    notifempty
    create 0644 root root
}
EOT

# Create log directory
mkdir -p /var/log/large-model-security

# Create systemd service for the security application
cat <<EOT > /etc/systemd/system/large-model-security.service
[Unit]
Description=Large Model Application Security Service
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/large-model-security
Environment=BAILIAN_API_KEY=${var.bailian_api_key}
Environment=ALIBABA_CLOUD_ACCESS_KEY_ID=${alicloud_ram_access_key.ram_access_key.id}
Environment=ALIBABA_CLOUD_ACCESS_KEY_SECRET=${alicloud_ram_access_key.ram_access_key.secret}
ExecStart=/usr/bin/python3 /opt/large-model-security/security_monitor.py
Restart=always
RestartSec=5
StandardOutput=append:/var/log/large-model-security/service.log
StandardError=append:/var/log/large-model-security/error.log

[Install]
WantedBy=multi-user.target
EOT

# Enable and start the service
systemctl daemon-reload
systemctl enable large-model-security
systemctl start large-model-security

# Configure firewall rules for web access
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --permanent --add-port=443/tcp
firewall-cmd --permanent --add-port=8080/tcp
firewall-cmd --reload

# Create simple web interface for monitoring
mkdir -p /var/www/html
cat <<EOT > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Large Model Security System</title>
    <meta charset="UTF-8">
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background-color: #f5f5f5; }
        .container { background: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { color: #1976d2; }
        .status { padding: 10px; margin: 10px 0; border-radius: 5px; }
        .status.active { background-color: #4caf50; color: white; }
        .info { background-color: #e3f2fd; padding: 15px; border-radius: 5px; margin: 20px 0; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Large Model Application Security System</h1>
        <div class="status active">Security System Status: Active</div>
        <div class="info">
            <h3>System Information</h3>
            <p><strong>Deployment:</strong> Alibaba Cloud ECS</p>
            <p><strong>Security Features:</strong> Content Moderation, API Key Management, Network Security</p>
            <p><strong>Monitoring:</strong> Real-time security monitoring enabled</p>
        </div>
        <div class="info">
            <h3>API Endpoints</h3>
            <p><strong>Health Check:</strong> /health</p>
            <p><strong>Security Status:</strong> /security/status</p>
            <p><strong>Logs:</strong> /logs</p>
        </div>
    </div>
</body>
</html>
EOT

# Install and configure nginx for web interface
yum install -y nginx
systemctl enable nginx
systemctl start nginx

echo "Large model application security system installation completed successfully!"
echo "Web interface available at: http://$(curl -s http://checkip.amazonaws.com)"
EOF
}

# Create VPC for the large model application security system
resource "alicloud_vpc" "vpc" {
  cidr_block  = var.vpc_config.cidr_block
  vpc_name    = var.vpc_config.vpc_name
  description = var.vpc_config.description
}

# Create VSwitch in the VPC
resource "alicloud_vswitch" "vswitch" {
  vpc_id       = alicloud_vpc.vpc.id
  cidr_block   = var.vswitch_config.cidr_block
  zone_id      = var.vswitch_config.zone_id
  vswitch_name = var.vswitch_config.vswitch_name
  description  = var.vswitch_config.description
}

# Create security group for the ECS instance
resource "alicloud_security_group" "security_group" {
  security_group_name = var.security_group_config.security_group_name
  vpc_id              = alicloud_vpc.vpc.id
  description         = var.security_group_config.description
  security_group_type = var.security_group_config.security_group_type
}

# Create security group rules using for_each for multiple rules
resource "alicloud_security_group_rule" "security_rules" {
  for_each = var.security_group_rules_config

  type              = each.value.type
  ip_protocol       = each.value.ip_protocol
  policy            = each.value.policy
  port_range        = each.value.port_range
  priority          = each.value.priority
  security_group_id = alicloud_security_group.security_group.id
  cidr_ip           = each.value.cidr_ip
  description       = each.value.description
}

# Create RAM user for accessing cloud services
resource "alicloud_ram_user" "ram_user" {
  name         = var.ram_user_config.name
  display_name = var.ram_user_config.display_name
  mobile       = var.ram_user_config.mobile
  email        = var.ram_user_config.email
  comments     = var.ram_user_config.comments
}

# Create access key for the RAM user
resource "alicloud_ram_access_key" "ram_access_key" {
  user_name = alicloud_ram_user.ram_user.name
  status    = var.ram_access_key_config.status
}

# Attach policies to RAM user using for_each for multiple policies
resource "alicloud_ram_user_policy_attachment" "policy_attachments" {
  for_each = {
    for idx, policy in var.ram_policy_attachments_config :
    "${policy.policy_name}-${idx}" => policy
  }

  user_name   = alicloud_ram_user.ram_user.name
  policy_type = each.value.policy_type
  policy_name = each.value.policy_name
}

# Create ECS instances using for_each for multiple instances
resource "alicloud_instance" "ecs_instances" {
  for_each = {
    for idx, instance in var.ecs_instances_config :
    "${instance.instance_name}-${idx}" => instance
  }

  instance_name              = each.value.instance_name
  image_id                   = each.value.image_id
  instance_type              = each.value.instance_type
  system_disk_category       = each.value.system_disk_category
  system_disk_size           = each.value.system_disk_size
  vswitch_id                 = alicloud_vswitch.vswitch.id
  security_groups            = [alicloud_security_group.security_group.id]
  password                   = each.value.password
  internet_max_bandwidth_out = each.value.internet_max_bandwidth_out
  availability_zone          = each.value.availability_zone
  instance_charge_type       = each.value.instance_charge_type
  description                = each.value.description
}

# Create ECS command for installing security tools
resource "alicloud_ecs_command" "install_command" {
  name = var.ecs_command_config.name
  command_content = base64encode(
    var.custom_installation_script != null ? var.custom_installation_script : local.default_installation_script
  )
  description = var.ecs_command_config.description
  type        = var.ecs_command_config.type
  working_dir = var.ecs_command_config.working_dir
  timeout     = var.ecs_command_config.timeout
}

# Execute the installation command on ECS instances using for_each
resource "alicloud_ecs_invocation" "install_invocations" {
  for_each = {
    for idx, instance in var.ecs_instances_config :
    "${instance.instance_name}-${idx}" => instance
  }

  command_id  = alicloud_ecs_command.install_command.id
  instance_id = [alicloud_instance.ecs_instances[each.key].id]
  username    = var.ecs_invocation_config.username

  timeouts {
    create = var.ecs_invocation_config.timeout_create
  }
}