output "instance_floating_ip" {
  description = "Instance public IP (via Floating IP)"
  value       = module.floatip.floating_ip
}

output "mongodb_connection_string" {
  description = "MongoDB Connection String"
  value       = module.db_engine.db_service_connection_string
}

output "mongodb_user_password" {
  description = "MongoDB User Password"
  value       = module.db_engine.db_user_password
  sensitive   = true
}
