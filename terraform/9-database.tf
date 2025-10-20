
resource "aws_security_group" "rds" {
  name        = "${local.env}-rds-sg"
  description = "Allow access to RDS from EKS"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
    description     = "Allow PostgreSQL from VPC (did not work with node group SG.)"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.env}-rds-sg"
  }
}

resource "aws_db_subnet_group" "rds" {
  name       = "${local.env}-rds-subnet-group"
  subnet_ids = [
    aws_subnet.private_zone1.id,
    aws_subnet.private_zone2.id
  ]

  tags = {
    Name = "${local.env}-rds-subnet-group"
  }
}

resource "aws_db_instance" "postgres" {
  identifier              = "${local.env}-postgres"
  engine                  = "postgres"
  engine_version          = "17.2"
  instance_class          = "db.r5.large"
  allocated_storage       = 20
  storage_type = "gp3"
  db_subnet_group_name    = aws_db_subnet_group.rds.name
  vpc_security_group_ids  = [aws_security_group.rds.id]
  publicly_accessible     = false #Set it to true in production
  skip_final_snapshot     = true #Default is false, delete this line in production
  deletion_protection     = false
  db_name                 = "kopefalva"
  username                = "dbadmin"
  password                = var.db_password
  port                    = 5432

  auto_minor_version_upgrade = true

  tags = {
    Name = "${local.env}-postgres"
  }
}