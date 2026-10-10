output "bastion_id" {
  description = "Resource ID of the Bastion host."
  value       = azurerm_bastion_host.this.id
}
