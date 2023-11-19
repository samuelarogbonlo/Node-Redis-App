
#Define IAM User Secret Key
variable "secret_key" {
  description = "The secret_key that belongs to the IAM user."
  type        = string
  sensitive   = true
  default     = ""
}

variable "replication_group_id" {
  description = "The name of the ElastiCache replication group."
  default     = "app-4-redis-cluster"
  type        = string
}

variable "source_Security_group" {

}

variable "vpc_id" {

}
variable "subnet_ids" {

}