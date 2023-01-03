output "bastion_public_ip" {
  description = "Bastion public IP (floating IP)"
  value       = module.mybastion.floating_ip
}

output "bastion_private_ip" {
  description = "Bastion private IP"
  value       = module.mybastion.bastion_private_ip
}

output "target_private_ip" {
  description = "Target private IP"
  value       = module.mytarget.target_private_ip
}
