# Private Network
module "network" {
  source  = "../../modules/private_network"
  region  = var.region
  network = var.network
  subnet  = var.subnet
  router  = var.router
}

# Managed MongoDB Database
module "db_engine" {
  source     = "../../modules/database/mongodb_pvnw"
  depends_on = [module.network]
  region     = var.region
  db_engine  = var.db_engine
}

# SSH Keypair
module "keypair" {
  source  = "../../modules/ssh_keypair"
  keypair = var.keypair
}

# Virtual Machine Instance
module "instance" {
  source     = "../../modules/instance_simple"
  depends_on = [module.keypair, module.network]
  instance   = var.instance
}

# Floating IP
module "floatip" {
  source     = "../../modules/floating_ip"
  depends_on = [module.instance]
  floatip = {
    region       = var.region
    component_id = module.instance.instance_id
  }
}

# Ansible inventory file
resource "local_file" "ansible_config" {
  content = templatefile("./templates/hosts.tftpl", {
    instance_public_ip = module.floatip.floating_ip
    instance_user_name = var.instance.user
    ssh_private_key_name = var.keypair.name
  })
  filename        = "${path.module}/apps/hosts"
  file_permission = "0644"
}

# Ansible Execution - Mongoshell Installation
resource "null_resource" "ansible_exec" {
  depends_on = [local_file.ansible_config]
  triggers   = { always_run = "${timestamp()}" }
  provisioner "local-exec" {
    command = "ansible-playbook -i apps/hosts apps/apps.yml"
  }
}
