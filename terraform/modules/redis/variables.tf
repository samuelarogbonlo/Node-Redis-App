
#Define IAM User Secret Key
variable "secret_key" {
  description = "The secret_key that belongs to the IAM user."
  type        = string
  sensitive   = true
  default     = ""
}

variable "replication_group_id" {
  description = "The name of the ElastiCache replication group."
  default     = "nodeapp-redis-cluster"
  type        = string
}

variable "source_Security_group" {
  description = "the allows sg to talk to redis"
}

variable "vpc_id" {
  description = "The VPC ID"
}
variable "subnet_ids" {
  description = "The private subnet id"
}
