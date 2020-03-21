# root of global

remote_state {
  backend = "s3"
  config = {
    bucket = "terraform-state-fcbh-dev-account-1-global"

    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "my-lock-table"
    profile        = "contrib-kh-admin"
  }
}

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = {
  aws_region  = "us-east-2"
  aws_profile = "contrib-kh-admin"
}

