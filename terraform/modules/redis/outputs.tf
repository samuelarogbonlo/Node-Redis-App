output "redis_port_arn" {
  value     = aws_ssm_parameter.elasticache_port.arn
  sensitive = true
}

output "redis_string_url_arn" {
  value     = aws_ssm_parameter.elasticache_ep.arn
  sensitive = true
}

output "kms_secret" {
  value = aws_kms_key.encrytion_secret.arn
}

output "kms_rest" {
  value     = aws_kms_key.encrytion_rest.arn
  sensitive = true
}

output "redis_auth_arn" {
  value     = aws_secretsmanager_secret_version.auth.arn
  sensitive = true
}

output "redis_enpoint_arn" {
  value = aws_ssm_parameter.elasticache_ep.arn
}
