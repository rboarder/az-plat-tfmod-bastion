variable "name" {
  description = "Name of the Bastion host."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group the Bastion is created in."
  type        = string
}

variable "location" {
  description = "Azure region. For the Developer SKU this must be a supported region."
  type        = string
}

variable "sku" {
  description = "Bastion SKU. Developer is free; the others bill hourly while deployed."
  type        = string
  default     = "Developer"

  validation {
    condition     = contains(["Developer", "Basic", "Standard", "Premium"], var.sku)
    error_message = "sku must be one of: Developer, Basic, Standard, Premium."
  }
}

variable "virtual_network_id" {
  description = "VNet ID. Used by the Developer SKU only."
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "ID of a subnet named AzureBastionSubnet (/26 or larger). Required for non-Developer SKUs."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags applied to resources."
  type        = map(string)
  default     = {}
}
