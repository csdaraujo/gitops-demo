variable "env" {
  type        = string
  description = "Environment ID"

  validation {
    condition     = can(regex("^dev|stg|prd$", var.env))
    error_message = "Invalid environment ID!"
  }
}

variable "acr" {
  type = object({
    name                = string,
    resource_group_name = string,
  })
  description = "Azure Container Registry data parameters"
}
