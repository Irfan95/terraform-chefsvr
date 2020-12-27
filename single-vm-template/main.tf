resource "azurerm_resource_group" "resource_gp" {
  name = ""
  location = var.location

  tags = {
    Owner = var.owner_name
  }
}

data "azurerm_subnet" "subnet" {
  name                 = var.existing_subnet_name
  virtual_network_name = var.existing_network_name
  resource_group_name  = var.existing_network_rg_name
}

resource "azurerm_public_ip" "pip" {
  name                = ""
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_gp.name
  allocation_method   = var.pip_allocation_method
  domain_name_label   = var.public_ip_dns_name
}

resource "azurerm_network_security_group" "nsg" {
  name                = ""
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_gp.name

  security_rule {
    name                       =  var.nsg-1_name 
    priority                   =  var.nsg-1_priority 
    direction                  =  var.nsg-1_direction 
    access                     =  var.nsg-1_access 
    protocol                   =  var.nsg-1_protocol 
    source_port_range          =  var.nsg-1_source_port_range 
    destination_port_range     =  var.nsg-1_destination_port_range 
    source_address_prefix      =  var.nsg-1_source_address_prefix 
    destination_address_prefix =  var.nsg-1_destination_address_prefix 
  }

  security_rule {
    name                       =  var.nsg-2_name 
    priority                   =  var.nsg-2_priority 
    direction                  =  var.nsg-2_direction 
    access                     =  var.nsg-2_access 
    protocol                   =  var.nsg-2_protocol 
    source_port_range          =  var.nsg-2_source_port_range 
    destination_port_range     =  var.nsg-2_destination_port_range 
    source_address_prefix      =  var.nsg-2_source_address_prefix 
    destination_address_prefix =  var.nsg-2_destination_address_prefix 
  }
  
  tags = {
    Owner = var.owner_name
  }
}

resource "azurerm_network_interface" "main" {
  name                      = ""
  location                  = var.location
  resource_group_name       = azurerm_resource_group.resource_gp.name
  network_security_group_id = azurerm_network_security_group.nsg.id

  ip_configuration {
    name                          = var.private_ip_name
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = var.private_ip_address_allocation
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = ""
  location              = var.location
  resource_group_name   = azurerm_resource_group.resource_gp.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = var.vm_size

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true


  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = var.os_publisher
    offer     = var.os_offer
    sku       = var.os_sku
    version   = var.os_version
  }
  storage_os_disk {
    name              = "osDisk1"
    caching           = var.os_disk_caching
    managed_disk_type = var.os_disk_managed_disk_type
    create_option     = var.os_disk_create_option
  }
  storage_data_disk {
    name              =  "DataDisk1"
    managed_disk_type =  var.data_disk_managed_disk_type
    create_option     =  var.data_disk_create_option 
    lun               =  var.data_disk_lun0 
    disk_size_gb      =  var.data_disk_size_sml 
  }
    storage_data_disk {
    name              =  "-DataDisk2"
    managed_disk_type =  var.data_disk_managed_disk_type 
    create_option     =  var.data_disk_create_option 
    lun               =  var.data_disk_lun1 
    disk_size_gb      =  var.data_disk_size_lrg 
  }

  os_profile {
    computer_name  = ""
    admin_username = var.username
    admin_password = var.password
  }
  os_profile_windows_config {
    provision_vm_agent = true
  }
  tags = {
    Owner = var.owner_name
  }
}

# WinRM Configuration # -------------------------------

resource "azurerm_virtual_machine_extension" "WinRM_Setup"  {
  name                 = "WinRM-Setup"
  virtual_machine_id   = azurerm_virtual_machine.main.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  settings = <<SETTINGS
  {
    "fileUris": ["AZURIPATH_TO_test.ps1"]
  }
  SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
      "commandtoExecute": "powershell -ExecutionPolicy Unrestricted -File ./test.ps1"
    }
  PROTECTED_SETTINGS
    depends_on = [
    azurerm_virtual_machine.main
  ]
}


# OS Configuration # ----------------------------------

resource "null_resource" "OS_Config" {
  provisioner "remote-exec" {
    connection {
      host      = azurerm_public_ip.pip.fqdn
      type      = "winrm"
      user      = var.username
      password  = var.password
      port      = var.winrm_port
      timeout   = var.winrm_timeout
      https     = var.winrm_https
      insecure  = true
    }
    inline = [
      "powershell -ExecutionPolicy Unrestricted -Command \"Write-Host 'Example PS Note'\""
    ]
  }
  depends_on = [
    azurerm_virtual_machine_extension.WinRM_Setup
  ]
}

# Chef Execution # -------------------------------------

resource "null_resource" "chef-client" {
  provisioner "chef" {
    connection {
      host      = azurerm_public_ip.pip.fqdn
      type      = "winrm"
      user      = var.username
      password  = var.password
      port      = var.winrm_port
      timeout   = var.winrm_timeout
      https     = var.winrm_https
      insecure  = true
    }

    node_name       = azurerm_virtual_machine.main.name
    user_name       = var.chef_validation_client_name
    user_key        = var.chef_validation_secret
    server_url      = var.chef_server_url
    environment     = var.chef_environment
    ssl_verify_mode = ":verify_none"
    run_list        = var.chef_runlist
    client_options  = ["chef_license 'accept'"]
    recreate_client = true
    version         = var.chef_client_version
    log_to_file     = true
  }
    depends_on = [
    azurerm_virtual_machine_extension.WinRM_Setup
  ]
}

