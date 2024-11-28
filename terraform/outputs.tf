output "resource_group_name" {
  value = azurerm_resource_group.keycloak_rg.name
}

output "public_ip_address" {
  value = azurerm_public_ip.keycloak_ip.ip_address
}

output "vm_name" {
  value = azurerm_linux_virtual_machine.keycloak_vm.name
}

output "vm_private_ip" {
  value = azurerm_network_interface.keycloak_nic.private_ip_address
}


