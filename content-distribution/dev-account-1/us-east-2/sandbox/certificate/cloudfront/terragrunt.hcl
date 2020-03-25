# member-account: dev-account-1

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../../../../fcbh-infrastructure-modules//certificate"
  # source = "git::https://github.com/faithcomesbyhearing/fcbh-infrastructure-modules.git?ref=master"
}

#Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

inputs = {
  aws_region                = "us-east-1" # certificate for cloudfront must be us-east-1 
  namespace                 = "bwflood"
  stage                     = "dev"
  name                      = "cf-certificate"
  domain_name               = "dev.bwfloodstudyaws.com"
  subject_alternative_names = ["cdn.dev.bwfloodstudyaws.com"]
}
