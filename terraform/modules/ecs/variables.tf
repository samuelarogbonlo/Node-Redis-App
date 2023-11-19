variable "vpc_id" {
  type        = string
  description = "The ID of the VPC to deploy resources into"
}

variable "public_subnets" {
  type        = list(string)
  description = "A list of subnets to deploy resources into"
}

variable "private_subnets" {
  type        = list(string)
  description = "A list of subnets to deploy resources into"
}


variable "env_code" {
  type        = string
  description = "production tag"
}

variable "redis_port_arn" {
  description = "The redis port"
}

variable "redis_string_url_arn" {
  description = "The redis password arn"

}

variable "kms_secret" {
  description = "The secret kms key arn"
}


variable "kms_rest" {
  description = "The kms at rest key"

}

variable "posgress_password_arn" {
  description = "The postgres password arn"
}

variable "posgress_endpoint_arn" {
  description = "The postgres Endpoint arn"
}

variable "redis_auth_arn" {
  description = "The redis password arn"
}

variable "redis_endpoint_arn" {
  description = "The redis endpoint arn"
}

variable "db_user_name" {
  description = "the name of the postgres DB user name"
}