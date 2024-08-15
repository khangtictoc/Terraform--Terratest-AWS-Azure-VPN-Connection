resource "aws_customer_gateway" "customer_gateway" {
  bgp_asn    = var.vpn_connection_config.aws_customer_gateway.bgp_asn
  ip_address = var.azure_vpn_network_config.virtual_network_gateway.public_ip_address
  type       = var.vpn_connection_config.aws_customer_gateway.type

  tags = merge(
    var.tags,
    {
      "Name" = var.vpn_connection_config.aws_customer_gateway.name
    }
  )
}

resource "aws_vpn_connection" "vpn_connection" {
  vpn_gateway_id      = var.aws_vpn_network_config.virtual_network_gateway.id
  customer_gateway_id = aws_customer_gateway.customer_gateway.id
  type                = var.vpn_connection_config.aws_vpn_connection.type
  static_routes_only  = var.vpn_connection_config.aws_vpn_connection.static_routes_only

  local_ipv4_network_cidr = var.vpn_connection_config.aws_vpn_connection.local_ipv4_network_cidr
  remote_ipv4_network_cidr =  var.vpn_connection_config.aws_vpn_connection.remote_ipv4_network_cidr

  tags = merge(
    var.tags,
    {
      "Name" = var.vpn_connection_config.aws_vpn_connection.name
    }
  )
}

resource "aws_vpn_connection_route" "vpn_static_routes" {
  destination_cidr_block = var.vpn_connection_config.aws_vpn_connection.static_route_cidr_blocks
  vpn_connection_id      = aws_vpn_connection.vpn_connection.id
}


resource "azurerm_local_network_gateway" "local_network_gateway" {
  name                = var.vpn_connection_config.aws_vpn_connection.name
  gateway_address     = aws_vpn_connection.vpn_connection.tunnel1_address
  address_space       = [for ipAddr in var.vpn_connection_config.azure_local_network_gateway.address_space : ipAddr]

  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
}

resource "azurerm_virtual_network_gateway_connection" "vpn_connection" {
  name                = var.vpn_connection_config.azure_virtual_network_gateway_connection.name
  type                       = var.vpn_connection_config.azure_virtual_network_gateway_connection.type
  virtual_network_gateway_id = var.azure_vpn_network_config.virtual_network_gateway.id
  local_network_gateway_id   = azurerm_local_network_gateway.local_network_gateway.id
  shared_key = aws_vpn_connection.vpn_connection.tunnel1_preshared_key

  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
}

### Update the route table to route traffic from created Vnet to the VPN gateway
resource "aws_route" "vpn_gateway_route" {
  route_table_id            = var.aws_vpn_network_config.vpc.default_route_table_id
  destination_cidr_block    = var.azure_vpn_network_config.virtual_network.address_space[0]
  gateway_id                = var.aws_vpn_network_config.virtual_network_gateway.id
}

resource "aws_route" "internet_gateway_route" {
  route_table_id            = var.aws_vpn_network_config.vpc.default_route_table_id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = var.aws_vpn_network_config.internet_gateway.id
}