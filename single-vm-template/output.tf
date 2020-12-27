output "FQDN" {
  value       = azurerm_public_ip.pip.fqdn
  description = "FQDN of the VM"
}

output "Public_IP_Address" {
  value       = azurerm_public_ip.pip.ip_address
  description = "Public IP address of VM"
}