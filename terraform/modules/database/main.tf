resource "aws_db_subnet_group" "main" {
  name       = var.env_code
  subnet_ids = var.subnet_ids

  tags = {
    Name = var.env_code
  }
}

resource "aws_security_group" "rds_sg" {
  name   = "${var.env_code}-rds"
  vpc_id = var.vpc_id

  ingress {
    description     = "connection form the ecs pods"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0", "10.0.0.0/16"]
  }

  tags = {
    Name = "${var.env_code}-rds"
  }
}

resource "aws_secretsmanager_secret" "db_auth" {
  name                    = "db-auth"
  recovery_window_in_days = 0
  #checkov:skip=CKV2_AWS_57: Disabled Secrets Manager secrets automatic rotation
}

resource "aws_secretsmanager_secret_version" "db" {
  secret_id     = aws_secretsmanager_secret.db_auth.id
  secret_string = random_password.db_password.result
}

resource "aws_db_instance" "rds-pgs" {
  identifier              = var.env_code
  allocated_storage       = 10
  engine                  = "postgres"
  engine_version          = "15.3"
  instance_class          = "db.t3.micro"
  username                = "lifinance_pro"
  password                = aws_secretsmanager_secret_version.db.secret_string
  multi_az                = true
  db_subnet_group_name    = aws_db_subnet_group.main.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  backup_retention_period = 35
  backup_window           = "21:00-23:00"
  iam_database_authentication_enabled = true
  final_snapshot_identifier = false
}
