output "bastion_floating_ip" {
  description = "Bastion public IP (via Floating IP)"
  value = module.floatip.floating_ip
}

output "bastion_private_ip" {
  description = "Bastion private IP"
  value = module.bastion.instance_private_ip
}

output "target_private_ip" {
  description = "Target private IP"
  value = module.target.instance_private_ip
}
