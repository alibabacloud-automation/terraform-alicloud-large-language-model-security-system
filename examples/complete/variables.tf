
variable "bailian_api_key" {
  description = "The API key for Bailian (DashScope) service. Required for accessing large model services."
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.bailian_api_key) > 0
    error_message = "The bailian_api_key cannot be empty."
  }
}

variable "ecs_instance_password" {
  description = "The password for ECS instance login. Must be 8-30 characters long and contain at least three types of characters: uppercase letters, lowercase letters, numbers, and special characters."
  type        = string
  sensitive   = true
}

variable "custom_installation_script" {
  description = "Custom installation script for security tools. If not provided, the default script will be used."
  type        = string
  default     = null
  sensitive   = true
}