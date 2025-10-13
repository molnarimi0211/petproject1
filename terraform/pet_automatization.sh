#!/bin/bash

# Step 1: Get EC2 and RDS addresses from Terraform
BASTION_HOST=$(terraform output -raw rds_bastion_ipv4)
RDS_HOST=$(terraform output -raw rds_endpoint)

# Step 2: Prompt for DB password securely
read -s -p "Enter PostgreSQL password for dbadmin: " DB_PASSWORD
echo

# Step 3.1 Copy the SQL file to the Bastion host
scp -i ~/Downloads/petproject-key.pem ../db_fillup.sql ubuntu@$BASTION_HOST:/home/ubuntu/


# Step 3.2: SSH into Bastion and run psql commands remotely
ssh -i ~/Downloads/petproject-key.pem ubuntu@$BASTION_HOST << EOF

# Export password for psql session
export PGPASSWORD="$DB_PASSWORD"

# Step 4: Connect to RDS and execute SQL commands from the file
psql -h $RDS_HOST -p 5432 -U dbadmin -d kopefalva -f /home/ubuntu/db_fillup.sql
EOF
