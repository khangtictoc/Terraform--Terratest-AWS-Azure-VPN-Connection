module "security_group" {
    source = "./security-group"

    security_group_config = var.aws_vm_config.security_group
    vpc_id = var.vpc_id

    tags = var.tags
}

module "keypair" {
    source = "./keypair"

    keypair_config = var.aws_vm_config.keypair
}

module "ec2_instance" {
    source = "./instance"

    instance_config = var.aws_vm_config.ec2
    security_group_ids = module.security_group.id
    subnet_id = var.subnet_id

    keypair_name = module.keypair.keypair_name
    tags          = var.tags
}

resource "local_file" "aws_private_ssh_key" {
    content  = module.keypair.ssh_private_key
    filename = "credentials/aws/private_key"
}

# resource "null_resource" "add_host_key" {
#   triggers = {
#     always_run = local_file.aws_private_ssh_key.id
#   }

#   provisioner "local-exec" {
#     command = <<EOT
#       icacls ./credentials/aws/private_key /inheritance:r /grant:r "$(whoami):(R,M)" "Administrators:F" "SYSTEM:(F)"
#     EOT
#     interpreter = ["PowerShell", "-Command"]
#   }

#   depends_on = [ local_file.aws_private_ssh_key ]
# }
