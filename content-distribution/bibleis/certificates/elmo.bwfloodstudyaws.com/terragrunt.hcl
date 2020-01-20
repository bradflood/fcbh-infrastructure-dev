# bibleis dbp-web

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../../fcbh-infrastructure-modules//certificates"
  #source = "git::https://github.com/bradflood/fcbh-infrastructure-modules.git?ref=master"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

inputs = {

  # # administrative, to match cloudposse label
  # namespace = "bibleis"
  # name      = "web"
  # stage     = "dev"
  domain_name               = "bwfloodstudyaws.com"
  subject_alternative_names = ["elmo.bwfloodstudyaws.com"]
}
