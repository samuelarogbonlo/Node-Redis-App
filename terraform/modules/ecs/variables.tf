variable "vpc_id" {
    type = string
    description = "The ID of the VPC to deploy resources into"
}

variable "public_subnets" {
    type = list(string)
    description = "A list of subnets to deploy resources into"
}

variable "private_subnets" {
    type = list(string)
    description = "A list of subnets to deploy resources into"
}


variable "env_code" {

}

variable "redis_port_arn" {

}

variable "redis_string_url_arn" {

}

variable "kms_secret" {

}


variable "kms_rest" {
  
}

variable "posgress_password_arn" {
  
}

variable "posgress_endpoint_arn" {
  
}

variable "redis_auth_arn" {
  
}

variable "redis_endpoint_arn" {
  
}

variable "db_user_name" {
  
}