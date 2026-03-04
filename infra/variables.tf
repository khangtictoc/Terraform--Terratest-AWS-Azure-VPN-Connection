############# AZURE #############

variable "tags" {}
variable "resource_group" {}

############# AWS #############

# General
variable "region" {}


########### VPN Site-to-Site Configuration ###########
variable s2s_vpn_connection_config {}
variable aws_vm_config_demo {}
variable azure_vm_config_demo {}