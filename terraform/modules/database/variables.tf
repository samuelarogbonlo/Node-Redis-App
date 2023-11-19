variable "subnet_ids" {
  description = "The privte subnet id"
}

variable "env_code" {
  type        = string
  description = "The production tag"
}

variable "vpc_id" {
  type        = string
  description = "The Vpc id"
}

variable "source_Security_group" {
  description = "The allowed sg to talk to the database"
}
