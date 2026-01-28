# Complete Example

This example demonstrates the complete usage of the Large Model Application Security System Terraform module. It creates a comprehensive security infrastructure for large model applications on Alibaba Cloud.

## Features Demonstrated

- **VPC Network Setup**: Creates a secure VPC with proper CIDR configuration
- **Multi-Instance Deployment**: Deploys multiple ECS instances (primary and backup) using for_each
- **Security Group Management**: Configures multiple security rules for different services (HTTP, HTTPS, SSH, custom app)
- **RAM User Management**: Creates RAM user with multiple policy attachments for different services
- **Automated Security Tools**: Installs and configures security monitoring tools automatically
- **Web Interface**: Provides a web-based monitoring interface for the security system

## Usage

1. **Set Required Variables**: Create a `terraform.tfvars` file with your configuration:

```hcl
bailian_api_key    = "your-bailian-api-key-here"
instance_password  = "YourSecurePassword123!"

# Optional: Custom installation script
# custom_installation_script = "#!/bin/bash\necho 'Custom security setup'\n# Your custom commands here"
```

2. **Initialize and Apply**:

```bash
# Initialize Terraform
terraform init

# Review the execution plan
terraform plan

# Apply the configuration
terraform apply
```

3. **Access the System**:

After deployment, you can access the security monitoring interface using the web URLs provided in the outputs.

## Configuration Details

### Multiple ECS Instances

This example creates two ECS instances:
- `primary`: Main security monitoring instance
- `backup`: Backup security monitoring instance

### Security Group Rules

Multiple security rules are configured:
- HTTP (port 80): Web interface access
- HTTPS (port 443): Secure web interface access
- SSH (port 22): Administrative access
- Custom App (port 8080): Application-specific access

### RAM Policies

Multiple policies are attached to the RAM user:
- `AliyunYundunGreenWebFullAccess`: Content moderation access
- `AliyunECSFullAccess`: ECS management access

## Outputs

The example provides comprehensive outputs including:
- Network resource IDs (VPC, VSwitch, Security Group)
- ECS instance information (IDs, names, IP addresses)
- Web access URLs for all instances
- RAM user information

## Customization

You can customize the deployment by:
- Modifying the `security_group_rules_config` to add/remove security rules
- Adjusting the `ecs_instances_config` to change instance configuration
- Providing a `custom_installation_script` for specialized security tools
- Changing the `ram_policy_attachments_config` to attach different policies

## Security Considerations

- Ensure your `instance_password` meets security requirements (8-30 characters with mixed case, numbers, and special characters)
- Keep your `bailian_api_key` secure and never commit it to version control
- Review and adjust security group rules based on your specific requirements
- Consider using Alibaba Cloud's Key Management Service (KMS) for additional security

## Cleanup

To destroy the resources created by this example:

```bash
terraform destroy
```

## Support

For issues related to this example, please refer to the main module documentation or contact the module maintainers.