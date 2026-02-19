// =========================================================================
// Outputs - Resource Groups
// =========================================================================

output "rg_primary_id" {
  value = azurerm_resource_group.primary.id
}
output "rg_primary_name" {
  value = azurerm_resource_group.primary.name
}
output "rg_primary_location" {
  value = azurerm_resource_group.primary.location
}

output "rg_networking_id" {
  value = azurerm_resource_group.networking.id
}
output "rg_networking_name" {
  value = azurerm_resource_group.networking.name
}

// =========================================================================
// Outputs - VM
// =========================================================================
output "vm1_id" {
  value = azurerm_linux_virtual_machine.vm1.id
}
output "vm1_name" {
  value = azurerm_linux_virtual_machine.vm1.name
}
