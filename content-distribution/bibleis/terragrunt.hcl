# content-distribution / bibleis dev

remote_state {
  backend = "s3"
  config = {
    bucket = "bibleis-terraform-state--970273885721"

    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "my-lock-table"
  }
}

inputs = {
  aws_region  = "us-east-2"
  aws_profile = "bwflood"
}