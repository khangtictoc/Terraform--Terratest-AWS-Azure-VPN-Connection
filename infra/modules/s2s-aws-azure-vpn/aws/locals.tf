locals {
  aws_network_info = {
    virtual_network_gateway = {
        id = aws_vpn_gateway.virtual_private_gateway.id
    }
    internet_gateway = {
        id = aws_internet_gateway.internet_gateway.id
    }
    vpc = {
        default_route_table_id = aws_vpc.vpn_vpc.default_route_table_id
        id = aws_vpc.vpn_vpc.id
    }
    subnet = aws_subnet.vpn_subnet.*

  }
}