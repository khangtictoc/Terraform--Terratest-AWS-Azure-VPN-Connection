resource "aws_vpc" "vpn_vpc" {
  cidr_block       = var.aws_vpn_network.vpc.cidr_block

  tags = merge(
    var.tags,
    {
      "Name" = var.aws_vpn_network.vpc.name
    }
  )
}


resource "aws_subnet" "vpn_subnet" {
  count = length(var.aws_vpn_network.vpc.subnet)
  vpc_id     = aws_vpc.vpn_vpc.id
  cidr_block = var.aws_vpn_network.vpc.subnet[count.index].cidr_block

  tags = merge(
    var.tags,
    {
      "Name" = var.aws_vpn_network.vpc.subnet[count.index].name
    }
  )
}

resource "aws_vpn_gateway" "virtual_private_gateway" {
  vpc_id = aws_vpc.vpn_vpc.id
  tags = merge(
    var.tags,
    {
      "Name" = var.aws_vpn_network.virtual_private_gateway.name
    }
  )
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpn_vpc.id
  tags = merge(
    var.tags,
    {
      "Name" = var.aws_vpn_network.internet_gateway.name
    }
  )
}