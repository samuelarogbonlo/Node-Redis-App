resource "aws_elasticache_subnet_group" "elasticache_subnet" {
  name       = "cache-subnet"
  subnet_ids = var.subnet_ids
}
resource "aws_kms_key" "encrytion_rest" {
  enable_key_rotation     = true
  description             = "Key to encrypt cache at rest"
  deletion_window_in_days = 7
  #checkov:skip=CKV2_AWS_64: Not including a KMS Key policy
}
resource "aws_kms_key" "encrytion_secret" {
  enable_key_rotation     = true
  description             = "Key to encrypt secret"
  deletion_window_in_days = 7
  #checkov:skip=CKV2_AWS_64: Not including a KMS Key policy
}
resource "aws_secretsmanager_secret" "elasticache_auth" {
  name                    = "elasticache-auth"
  recovery_window_in_days = 0
  kms_key_id              = aws_kms_key.encrytion_secret.id
  #checkov:skip=CKV2_AWS_57: Disabled Secrets Manager secrets automatic rotation
}
resource "aws_secretsmanager_secret_version" "auth" {
  secret_id     = aws_secretsmanager_secret.elasticache_auth.id
  secret_string = random_password.auth.result
}
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group
resource "aws_elasticache_replication_group" "app4" {
  automatic_failover_enabled = true
  subnet_group_name          = aws_elasticache_subnet_group.elasticache_subnet.name
  replication_group_id       = var.replication_group_id
  description                = "ElastiCache cluster for node-app"
  node_type                  = "cache.t2.small"
  parameter_group_name       = "default.redis7.cluster.on"
  port                       = 6379
  multi_az_enabled           = true
  num_node_groups            = 1
  replicas_per_node_group    = 1
  at_rest_encryption_enabled = true
  kms_key_id                 = aws_kms_key.encrytion_rest.id
  transit_encryption_enabled = true
  auth_token                 = aws_secretsmanager_secret_version.auth.secret_string
  security_group_ids         = [aws_security_group.elasticache.id]
  lifecycle {
    ignore_changes = [kms_key_id]
  }
  apply_immediately = true
}
