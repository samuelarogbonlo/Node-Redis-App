output "vpc-id" {
  value = module.vpc.vpc-id
}

output "subnet_id_public" {
  value = module.vpc.subnet_id_public
}

output "subnet_id_private" {
  value = module.vpc.subnet_id_private
}

output "vpc_cidr" {
  value = var.vpc_cidr
  sensitive = true
}
