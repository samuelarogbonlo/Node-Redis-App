data "terraform_remote_state" "vpc-layer" {
  backend = "s3"

  config = {
    bucket = "lifinance-challange"
    key    = "network/lifinance.tfstate"
    region = "eu-west-1"
  }
}
