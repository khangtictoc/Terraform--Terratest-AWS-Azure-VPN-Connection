output aws_vpn_connection {
    value = aws_vpn_connection.vpn_connection
}

output azure_vpn_connection {
    value = azurerm_virtual_network_gateway_connection.vpn_connection
}