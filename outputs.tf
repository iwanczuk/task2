output "database_user_password" {
  sensitive   = true
  value       = module.database.generated_user_password
  description = "The password for default user."
}
