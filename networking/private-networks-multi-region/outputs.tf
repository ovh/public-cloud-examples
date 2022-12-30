output "bastion_public_ip" {
 value = module.mybastion.floating_IP
}

output "bastion_private_ip" {
 value = module.mybastion.bastion_private_IP
}

output "target_private_ip" {
  value = module.mytarget.target_private_IP
}
