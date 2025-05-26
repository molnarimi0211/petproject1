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


################################
# IAM Roles For Service Account
################################


resource "aws_secretsmanager_secret" "database_credentials" {
  name = "${local.env}-kopepdb"  ##ezt kell átírni
}

resource "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id     = aws_secretsmanager_secret.database_credentials.id
  secret_string = jsonencode({
    username = "dbadmin"
    password = var.db_password
    engine   = "postgres"
    host     = aws_db_instance.postgres.address
    port     = 5432
    dbname   = "webcontent"
  })
}

resource "aws_iam_policy" "secretsmanager_read_policy" {  #IAM policy a secret elérésére
  name        = "${local.env}-secretsmanager-read"
  description = "Allows EKS pods to read database credentials from Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue"
        ],
        Resource = aws_secretsmanager_secret.database_credentials.arn
      }
    ]
  })
}

resource "aws_iam_role" "eks_secrets_access_role" { #IAM Role for Service Account
  name = "${local.env}-eks-secrets-access-role"

  assume_role_policy = data.aws_iam_policy_document.eks_assume_role_policy.json
}

data "aws_iam_policy_document" "eks_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.oidc.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.oidc.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:default:db-access-sa"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "attach_secrets_policy" {
  role       = aws_iam_role.eks_secrets_access_role.name
  policy_arn = aws_iam_policy.secretsmanager_read_policy.arn
}

resource "aws_iam_openid_connect_provider" "oidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da0afd10f27"]
  url             = aws_eks_cluster.eks.identity[0].oidc[0].issuer
}