locals {
  # true when the free Developer SKU is chosen
  is_developer = var.sku == "Developer"
}

# Basic/Standard/Premium need a public IP. Developer does not.
# count = 0 means "create nothing"; count = 1 means "create one".
resource "azurerm_public_ip" "this" {
  count = local.is_developer ? 0 : 1

  name                = "${var.name}-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_bastion_host" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  tags                = var.tags

  # Developer SKU attaches to the VNet directly...
  virtual_network_id = local.is_developer ? var.virtual_network_id : null

  # ...other SKUs use an ip_configuration block instead.
  # A dynamic block creates the block 0 or 1 times.
  dynamic "ip_configuration" {
    for_each = local.is_developer ? [] : [1]

    content {
      name                 = "ipconfig"
      subnet_id            = var.subnet_id
      public_ip_address_id = azurerm_public_ip.this[0].id
    }
  }

  lifecycle {
    precondition {
      condition     = local.is_developer ? var.virtual_network_id != null : var.subnet_id != null
      error_message = "Developer SKU needs virtual_network_id; other SKUs need subnet_id (AzureBastionSubnet)."
    }
  }
}
