variable "db_password" {
  description = "The password for the RDS PostgreSQL user"
  type        = string
  sensitive   = true
}

variable "key_name" {
  description = "The name of the SSH key pair"
  type        = string
  
}
