# member-account: dev-account-1

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../../../../fcbh-infrastructure-modules//elasticache"
  # source = "git::https://github.com/faithcomesbyhearing/fcbh-infrastructure-modules.git?ref=master"
}

#Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  namespace       = "dbp"
  stage           = "dev"
  name            = "api"
  vpc_id          = dependency.vpc.outputs.vpc_id
  private_subnets = dependency.vpc.outputs.private_subnet_ids
}
