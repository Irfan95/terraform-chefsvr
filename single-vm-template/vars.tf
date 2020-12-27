provider "azurerm" {
    version = "=1.42.0"
    subscription_id = var.subscription_id
    client_id       = var.client_id
    client_secret   = var.client_secret
    tenant_id       = var.tenant_id
}

variable "subscription_id" {
    description = "Enter the Subscription ID that will be used for provisioning resources in Azure"
}

variable "client_id" {
    description = "Enter the Client ID for the Application created in Azure Active Directory"
}

variable "client_secret" {
    description = "Enter the Client Secret for the Application created in Azure Active Directory"
}

variable "tenant_id" {
    description = "Enter the Tenant ID / Directory ID of your Azure Active Directory"
}

variable "location" {
    description = "Enter the location all your resources will use"
    default     = ""
}

variable "owner_name" {
    description = "Enter the name of the owner who created the resources"
    default     = ""
}

variable "existing_network_rg_name" {
    description = "Enter the resource group name the existing network resides in."
    default     = ""
}

variable "existing_network_name" {
    description = "Enter the name of the existing network you want to join the new VM to"
    default     = ""
}

variable "existing_subnet_name" {
    description = "Enter the subnet name from the existing network you want to add the new VM to"
    default     = ""
}

variable "public_ip_dns_name" {
    description = "Enter the name of the VM to be used in defining the DNS name in Azure"
    default     = ""    
}

variable "pip_allocation_method" {
    description = "Enter whether you want a Static or Dynamic Public IP Address"
    default     = "Static"
}

variable "private_ip_name" {
    description = "Enter the name of the Private IP configuration"
    default     = "ipconfiguration"
}

variable "private_ip_address_allocation" {
    description = "Enter whether you want a Static or Dynamic Private IP Address"
    default     = "dynamic"
}

## NSG 1
variable "nsg-1_name" {
    description = "Enter the name of the 1st Network Security Group"
    default     = ""
}

variable "nsg-1_priority" {
    description = "Enter the Priority of the 1st Network Security Group"
    default     = "100"
}

variable "nsg-1_direction" {
    description = "Enter the direction (Acceptable values {Inbound} {Outbound})"
    default     = "Inbound"
}

variable "nsg-1_access" {
    description = "Enter whether you want to allow or deny access (Acceptable values {Allow} {Deny})"
    default     = "Allow"
}

variable "nsg-1_protocol" {
    description = "Enter the Protocol (Acceptable values {TCP} {UDP} {ICMP} {*})"
    default     = "*"
}

variable "nsg-1_source_port_range" {
    description = "Enter the source port or range (Integer or range between 0 and 65535 or *)"
    default     = "*"
}

variable "nsg-1_destination_port_range" {
    description = "Enter the source port or range (Integer or range between 0 and 65535 or *)"
    default     = ""
}

variable "nsg-1_source_address_prefix" {
    description = "Enter the source address (CIDR or source IP range or * to match any IP)"
    default     = "" 
}

variable "nsg-1_destination_address_prefix" {
    description = "Enter the destination address (CIDR or source IP range or * to match any IP)"
    default     = "*"
}

## NSG 2
variable "nsg-2_name" {
    description = "Enter the name of the 2nd Network Security Group"
    default     = ""
}

variable "nsg-2_priority" {
    description = "Enter the Priority of the 2nd Network Security Group"
    default     = "101"
}

variable "nsg-2_direction" {
    description = "Enter the direction (Acceptable values {Inbound} {Outbound})"
    default     = "Inbound"
}

variable "nsg-2_access" {
    description = "Enter whether you want to allow or deny access (Acceptable values {Allow} {Deny})"
    default     = "Allow"
}

variable "nsg-2_protocol" {
    description = "Enter the Protocol (Acceptable values {TCP} {UDP} {ICMP} {*})"
    default     = "TCP"
}

variable "nsg-2_source_port_range" {
    description = "Enter the source port or range (Integer or range between 0 and 65535 or *)"
    default     = "*"
}

variable "nsg-2_destination_port_range" {
    description = "Enter the source port or range (Integer or range between 0 and 65535 or *)"
    default     = ""
}

variable "nsg-2_source_address_prefix" {
    description = "Enter the source address (CIDR or source IP range or * to match any IP)"
    default     = "" 
}

variable "nsg-2_destination_address_prefix" {
    description = "Enter the destination address (CIDR or source IP range or * to match any IP)"
    default     = "*"
}

variable "vm_size" {
    description = "Enter the VM size you want to use"
    default     = "Standard_B4ms"
}

variable "os_publisher" {
    description = "Enter the name of the publisher of the image"
    default     = "MicrosoftWindowsServer"
}

variable "os_offer" {
    description = "Enter the name of the OS"
    default     = "WindowsServer"
}

variable "os_sku" {
    description = "Enter the SKU of the OS"
    default     = "2016-Datacenter"
}

variable "os_version" {
    description = "Enter the version of the OS (Acceptable values {specific version no.} {latest})"
    default     = "latest"
}

variable "os_disk_caching" {
    description = "Select the caching option on the OS disk (Acceptable values {ReadWrite} {ReadOnly} {None})"
    default     = "ReadWrite"
}

variable "os_disk_managed_disk_type" {
    description = "Specifies the type of managed disk to create. Possible values are either {Standard_LRS} {StandardSSD_LRS} {Premium_LRS} {UltraSSD_LRS}"
    default     = "Standard_LRS"
}

variable "os_disk_create_option" {
    description = "Select how the data disk should be created (Acceptable values {Attach} {FromImage} {Empty})"
    default     = "FromImage"
}

variable "data_disk_managed_disk_type" {
    description = "Specifies the type of managed disk to create. Possible values are either {Standard_LRS} {StandardSSD_LRS} {Premium_LRS} {UltraSSD_LRS}"
    default     = "Standard_LRS"
}

variable "data_disk_create_option" {
    description = "Select how the data disk should be created (Acceptable values {Attach} {FromImage} {Empty})"
    default     = "Empty"
}

variable "data_disk_lun0" {
    description = "Specifies the logical unit number of the data disk (This needs to be unique within all the Data Disks on the Virtual Machine)"
    default     = "0"
}

variable "data_disk_lun1" {
    description = "Specifies the logical unit number of the data disk (This needs to be unique within all the Data Disks on the Virtual Machine)"
    default     = "1"
}

variable "data_disk_size_sml" {
    description = "Specifies the size of the data disk in gigabytes"
    default     = "127"
}

variable "data_disk_size_lrg" {
    description = "Specifies the size of the data disk in gigabytes"
    default     = "255"
}

variable "username" {
    description = "Username for the administrator account"
    default     = ""
}

variable "password" {
    description = "Password for the administrator account"
    default     = ""
}

variable "chef_runlist" {
    description = "List of Chef Recipes/Roles to run"
    default     = [
        "recipe[generic::default]",
        "role[generic]"
    ]
}

variable "winrm_port" {
    description = "Port used for WinRM connectivity"
    default     = "5985"
}

variable "winrm_timeout"{
    description = "Define the timeout period for WinRM connection attempt"
    default     = "1h"
}

variable "winrm_https" {
    description = "Define if you would want https to be used when connecting via WinRM"
    default     = "false"
}

variable "chef_client_version" {
    description = "Define the version of Chef-Client to be used/installed"
    default     = "15.10"
}

variable "chef_environment" {
    description = "Specify which Chef environment will be used"
    default     = ""
}

variable "chef_server_url" {
    description = "Specify the Chef Servers URL"
    default     = ""
}

variable "chef_server_ip" {
    description = "Specify the Public IP address of the Chef Server"
    default     = ""
}

variable "chef_validation_client_name" {
    description = "Specify the Client name to use to Authenticate with the Chef Server"
    default     = ""
}

variable "chef_validation_secret" {
    description = "Specify the Client Secret to use to Authenticate with the Chef Server"
    default     = ""
}

