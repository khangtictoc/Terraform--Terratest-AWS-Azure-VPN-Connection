## ========== ENVIRONMENT ========== ##
tags = {
  createdBy   = "Terraform"
  author      = "khangtictoc"
  environment = "dev"
  project     = "lab_extra_03"
}

### AZURE ###

### AWS ###
region = "us-east-1"

### Azure working space ###
resource_group = [
  {
    name     = "VPNSite2SiteDemo",
    location = "East Asia"
  },
  {
    name     = "VPNSite2SiteDemo2",
    location = "East Asia"
  }
]

##### VPN Site-to-Site Configuration #####
s2s_vpn_connection_config = {
  # AWS VPN Network
  aws_vpn_network = {
    vpc = {
      name       = "vpn-vpc"
      cidr_block = "192.168.0.0/16"
      subnet = [
        {
          cidr_block = "192.168.1.0/24"
          name       = "vpn-subnet"
        }
      ]
    }
    virtual_private_gateway = {
      name = "vpn-gateway"
    }
    internet_gateway = {
      name = "internet-gateway-vpn-test"
    }
  }

  # Azure VPN Network
  azure_vpn_network = [
    {
      virtual_network = {
        name          = "VpnVnet"
        address_space = ["172.16.0.0/16"]
        subnet = [
          {
            name           = "GatewaySubnet"
            address_prefix = ["172.16.0.0/27"]
          },
          {
            name           = "AppSubnet"
            address_prefix = ["172.16.1.0/24"]
          },
          {
            name           = "AppGatewaySubnet"
            address_prefix = ["172.16.2.0/24"]
          }
        ]
      }
      public_ip = {
        name              = "VNet-Gateway"
        allocation_method = "Static"
        sku               = "Standard"
        zones             = ["1", "2", "3"]
      }
      virtual_network_gateway = {
        name          = "Vnet-Gateway-Demo"
        type          = "Vpn"
        vpn_type      = "RouteBased"
        active_active = false
        enable_bgp    = false
        sku           = "VpnGw1AZ"
        ip_configuration = {
          name                          = "Vnet-Gateway-IP-Config"
          private_ip_address_allocation = "Dynamic"
        }
      }
    },
    {
      virtual_network = {
        name          = "VpnVnet2"
        address_space = ["10.10.0.0/16"]
        subnet = [
          {
            name           = "GatewaySubnet"
            address_prefix = ["10.10.0.0/27"]
          },
          {
            name           = "AppSubnet"
            address_prefix = ["10.10.1.0/24"]
          },
          {
            name           = "AppGatewaySubnet"
            address_prefix = ["10.10.2.0/24"]
          }
        ]
      }

      public_ip = {
        name              = "VNet-Gateway2"
        allocation_method = "Static"
        sku               = "Standard"
        zones             = ["1", "2", "3"]
      }

      virtual_network_gateway = {
        name     = "Vnet-Gateway-Demo2"
        type     = "Vpn"
        vpn_type = "RouteBased"

        active_active = false
        enable_bgp    = false
        sku           = "VpnGw1AZ"

        ip_configuration = {
          name                          = "Vnet-Gateway-IP-Config2"
          private_ip_address_allocation = "Dynamic"
        }
      }
    }
  ]

  vpn_connection_config = [
    {
      aws_customer_gateway = {
        name    = "my-customer-gateway"
        bgp_asn = 65000
        type    = "ipsec.1"
      }
      aws_vpn_connection = {
        name                     = "my-vpn-connection"
        type                     = "ipsec.1"
        static_routes_only       = true
        static_route_cidr_blocks = "172.16.0.0/16"
        local_ipv4_network_cidr  = "0.0.0.0/0"
        remote_ipv4_network_cidr = "0.0.0.0/0"
      }
      azure_local_network_gateway = {
        name          = "myLocalGW"
        address_space = ["192.168.0.0/16"]
      }
      azure_virtual_network_gateway_connection = {
        name = "myVnetGWConn"
        type = "IPsec"
      }
    },
    {
      aws_customer_gateway = {
        name    = "my-customer-gateway2"
        bgp_asn = 65000
        type    = "ipsec.1"
      }
      aws_vpn_connection = {
        name                     = "my-vpn-connection2"
        type                     = "ipsec.1"
        static_routes_only       = true
        static_route_cidr_blocks = "10.10.0.0/16"
        local_ipv4_network_cidr  = "0.0.0.0/0"
        remote_ipv4_network_cidr = "0.0.0.0/0"
      }
      azure_local_network_gateway = {
        name          = "myLocalGW2"
        address_space = ["192.168.0.0/16"]
      }
      azure_virtual_network_gateway_connection = {
        name = "myVnetGWConn2"
        type = "IPsec"
      }
    }
  ]
}

##### VMs Demo #####
aws_vm_config_demo = [
  {
    keypair = {
      name = "mykey"
    }
    ec2 = {
      name                        = "target01"
      ami_id                      = "ami-06aa3f7caf3a30282"
      instance_type               = "t2.medium"
      user_data_file              = null
      associate_public_ip_address = true

      ebs_block_device = {
        device_name = "/dev/sda1"
        volume_size = 30
      }

      instance_market_options = {
        market_type = "spot"
        spot_options = {
          instance_interruption_behavior = "terminate"
          max_price                      = null
        }
      }
    }
    security_group = {
      name        = "AllowAll"
      description = "Allow all traffic"
      security_group_rule = [
        {
          type        = "ingress"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          type        = "egress"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    }
  }
]

azure_vm_config_demo = [
  {
    virtual_machine = {
      name           = "source01"
      size           = "Standard_F1s"
      admin_username = "azureadmin"
      computer_name  = "myLinuxAgent01"
      os_disk = {
        name                 = "myOsDisk01"
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
      }
      source_image_reference = {
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-focal"
        sku       = "20_04-lts"
        version   = "latest"
      }
      public_key_path = "./credentials/azure/private_key/id_rsa.pub"

      eviction_policy = "Delete"
      priority        = "Spot"
    }
    network_interface = {
      name = "myNIC01"
      ip_configuration = {
        name                          = "internal"
        private_ip_address_allocation = "Dynamic"
      }
      public_ip = {
        name              = "myPublicIP01"
        allocation_method = "Dynamic"
      }
    }
    network_security_group = {
      name = "myNSG01"
      security_rule = [
        {
          name                       = "AllowAllInbound"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        },
        {
          name                       = "AllowAllOutbound"
          priority                   = 100
          direction                  = "Outbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        }
      ]
    }
  },
  {
    virtual_machine = {
      name           = "source02"
      size           = "Standard_F1s"
      admin_username = "azureadmin"
      computer_name  = "myLinuxAgent02"
      os_disk = {
        name                 = "myOsDisk02"
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
      }
      source_image_reference = {
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-focal"
        sku       = "20_04-lts"
        version   = "latest"
      }
      public_key_path = "./credentials/azure/private_key/id_rsa.pub"

      eviction_policy = "Delete"
      priority        = "Spot"
    }
    network_interface = {
      name = "myNIC02"
      ip_configuration = {
        name                          = "internal"
        private_ip_address_allocation = "Dynamic"
      }
      public_ip = {
        name              = "myPublicIP02"
        allocation_method = "Dynamic"
      }
    }
    network_security_group = {
      name = "myNSG02"
      security_rule = [
        {
          name                       = "AllowAllInbound"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        },
        {
          name                       = "AllowAllOutbound"
          priority                   = 100
          direction                  = "Outbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        }
      ]
    }
  }
]
