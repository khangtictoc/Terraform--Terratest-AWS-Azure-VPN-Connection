locals {
  azure_network_info = {
    virtual_network_gateway = {
        id = azurerm_virtual_network_gateway.virtual_network_gateway.id
        public_ip_address = azurerm_public_ip.vpn_public_ip.ip_address
        subnet_id = azurerm_virtual_network_gateway.virtual_network_gateway.ip_configuration[0].subnet_id
    }

    virtual_network = {
        id = azurerm_virtual_network.vpn_virtual_network.id
        address_space = azurerm_virtual_network.vpn_virtual_network.address_space
        subnets = azurerm_virtual_network.vpn_virtual_network.subnet
    }
    subnet = azurerm_subnet.vpn_subnet.*
  }
}