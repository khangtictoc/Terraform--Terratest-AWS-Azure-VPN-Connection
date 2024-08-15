locals {
  vpn_connection_output = {
    aws_vpn_network_info = module.aws_network.aws_vpn_network_info
    aws_vpn_connection_info = module.vpn_SiteToSite_connection.*.aws_vpn_connection
    azure_vpn_network_info = module.azure_network.*.azure_vpn_network_info
    azure_vpn_connection_info = module.vpn_SiteToSite_connection.*.azure_vpn_connection
  }
}