resource "aws_s3_bucket" "terraform_remote_state" {
  bucket = "lifinance-challange"
}

resource "aws_dynamodb_table" "terraform-lock" {
  name           = "lifinance-challange-remote-state"
  read_capacity  = 1
  write_capacity = 1
  billing_mode   = "PROVISIONED"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
