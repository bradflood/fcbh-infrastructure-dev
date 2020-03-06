# member-account: dbp

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../../../../../fcbh-infrastructure-modules//certificate"
  # source = "git::https://github.com/faithcomesbyhearing/fcbh-infrastructure-modules.git?ref=master"
}

#Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

inputs = {
  namespace                   = "dbp"
  stage                       = "prod"
  name                        = "certificate"
  domain_name                 = "v4.bwfloodstudyaws.com"
  subject_alternative_names   = ["api.v4.bwfloodstudyaws.com"]
}
