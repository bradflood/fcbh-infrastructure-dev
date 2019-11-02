# root of global

remote_state {
  backend = "s3"
  config = {
    bucket = "bwf-dev-fcbh-terraform-state-legacy"

    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "my-lock-table"
  }
}

#
# aws_region: region in which organization resources will be created
# 
# aws_profile: refers to a named profile (https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) 
# with sufficient permissions to create resources in the master account. 
#
inputs = {
  aws_region                        = "us-east-2"
  aws_profile                       = "bwflood"
}

#terragrunt import aws_s3_bucket_public_access_block.cloudfront-origin