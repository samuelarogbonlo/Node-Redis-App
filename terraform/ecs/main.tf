module "ecs"{
    source = "../modules/ecs"
    env_code              = var.env_code
    vpc_id = data.terraform_remote_state.vpc-layer.outputs.vpc-id
    public_subnets = data.terraform_remote_state.vpc-layer.outputs.subnet_id_public
    private_subnets = data.terraform_remote_state.vpc-layer.outputs.subnet_id_private
    redis_port_arn = module.redis.redis_port_arn
    redis_string_url_arn = module.redis.redis_string_url_arn
    kms_secret = module.redis.kms_secret
    kms_rest = module.redis.kms_rest
    posgress_password_arn = module.rds.db_password_arn
    posgress_endpoint_arn = module.rds.rds-pgs_string_arn
    redis_auth_arn = module.redis.redis_auth_arn
    redis_endpoint_arn = module.redis.redis_enpoint_arn
    db_user_name = module.rds.db_user_name 
}

module "rds" {
  source = "../modules/database"

  subnet_ids            = data.terraform_remote_state.vpc-layer.outputs.subnet_id_private
  env_code              = var.env_code
  vpc_id                = data.terraform_remote_state.vpc-layer.outputs.vpc-id
  source_Security_group = module.ecs.security_group_id
}

module "redis" {
  source = "../modules/redis"
  source_Security_group = module.ecs.security_group_id
  vpc_id                = data.terraform_remote_state.vpc-layer.outputs.vpc-id
  subnet_ids            = data.terraform_remote_state.vpc-layer.outputs.subnet_id_private
}