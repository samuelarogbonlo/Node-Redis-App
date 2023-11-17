variable "env_code" {
    description = "Name of the virtual Private cloud"
    type        = string
}

variable "vpc_cidr" {
    description = "virtual Private cloud Cidr Blocks"
    type        = string
}

variable "private_cidr" {
    description = "AWS private subnet Cidr Blocks"
    type        = list
}

variable "public_cidr" {
    description = "AWS private subnet Cidr Blocks"
    type        = list
}
