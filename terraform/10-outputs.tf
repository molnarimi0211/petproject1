
output "rds_endpoint" {
  value = aws_db_instance.postgres.address
}

output "rds_bastion_ipv4" {
  value = aws_instance.rds_bastion.public_dns
}