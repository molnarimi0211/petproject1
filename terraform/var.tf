# Külön változó a jelszónak
variable "db_password" {
  description = "The password for the RDS PostgreSQL user"
  type        = string
  sensitive   = true
}
