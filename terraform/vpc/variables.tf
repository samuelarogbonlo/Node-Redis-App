variable "env_code" {
  description = "Name of the virtual Private cloud"
  type        = string
  sensitive   = true
  default     = "sam-vpc"
}

variable "vpc_cidr" {
  description = "virtual Private cloud Cidr Blocks"
  type        = string
  sensitive   = true
  default     = "10.0.0.0/16"
}

variable "private_cidr" {
  description = "AWS private subnet Cidr Blocks"
  type        = list(any)
  sensitive   = true
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "public_cidr" {
  description = "AWS private subnet Cidr Blocks"
  type        = list(any)
  sensitive   = true
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}
