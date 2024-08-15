module "aws_network" {
    source = "./aws"

    aws_vpn_network = var.s2s_vpn_connection_config.aws_vpn_network

    tags = var.tags
}



module "azure_network" {
    count = length(var.s2s_vpn_connection_config.azure_vpn_network)
    source = "./azure"

    azure_vpn_network = var.s2s_vpn_connection_config.azure_vpn_network[count.index]

    tags = var.tags
    resource_group = var.resource_group[count.index]
}


module "vpn_SiteToSite_connection" {
    source = "./s2s-vpn-connection"
    count = length(var.s2s_vpn_connection_config.vpn_connection_config)

    vpn_connection_config = var.s2s_vpn_connection_config.vpn_connection_config[count.index]
    aws_vpn_network_config = module.aws_network.aws_vpn_network_info
    azure_vpn_network_config = module.azure_network[count.index].azure_vpn_network_info

    tags = var.tags
    resource_group = var.resource_group[count.index]
}