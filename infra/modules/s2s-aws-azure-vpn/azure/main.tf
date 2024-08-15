resource "azurerm_virtual_network" "vpn_virtual_network" {
    name                = var.azure_vpn_network.virtual_network.name
    address_space       = [for space in var.azure_vpn_network.virtual_network.address_space : space]

    tags = var.tags
    resource_group_name = var.resource_group.name
    location            = var.resource_group.location
}


resource "azurerm_subnet" "vpn_subnet" {
    count = length(var.azure_vpn_network.virtual_network.subnet)

    name                 = var.azure_vpn_network.virtual_network.subnet[count.index].name
    virtual_network_name = azurerm_virtual_network.vpn_virtual_network.name
    address_prefixes     = [for cidr in var.azure_vpn_network.virtual_network.subnet[count.index].address_prefix : cidr]
    
    resource_group_name  = var.resource_group.name
}

resource "azurerm_public_ip" "vpn_public_ip" {
    name                = var.azure_vpn_network.public_ip.name
    sku                 = var.azure_vpn_network.public_ip.sku
    allocation_method   = var.azure_vpn_network.public_ip.allocation_method

    tags = var.tags
    resource_group_name = var.resource_group.name
    location            = var.resource_group.location
}

resource "azurerm_virtual_network_gateway" "virtual_network_gateway" {
    name                = var.azure_vpn_network.virtual_network_gateway.name
    type     = var.azure_vpn_network.virtual_network_gateway.type
    vpn_type = var.azure_vpn_network.virtual_network_gateway.vpn_type

    active_active = var.azure_vpn_network.virtual_network_gateway.active_active
    enable_bgp    = var.azure_vpn_network.virtual_network_gateway.enable_bgp
    sku           = var.azure_vpn_network.virtual_network_gateway.sku

    ip_configuration {
        name                          = var.azure_vpn_network.virtual_network_gateway.ip_configuration.name
        public_ip_address_id          = azurerm_public_ip.vpn_public_ip.id
        private_ip_address_allocation = var.azure_vpn_network.virtual_network_gateway.ip_configuration.private_ip_address_allocation
        subnet_id                     = azurerm_subnet.vpn_subnet[0].id
    }

    tags = var.tags
    location            = var.resource_group.location
    resource_group_name = var.resource_group.name
}