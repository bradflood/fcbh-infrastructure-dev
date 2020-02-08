# member-account: dbp

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../../../fcbh-infrastructure-modules//elastic-beanstalk"
  # source = "git::https://github.com/bradflood/fcbh-infrastructure-modules.git?ref=master"
}

#Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}


#
# aws_region: region in which organization resources will be created
# 
# aws_profile: refers to a named profile (https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) 
# with sufficient permissions to create resources in the master account. 
#
# to copy an RDS snapshot between accounts: https://aws.amazon.com/premiumsupport/knowledge-center/rds-snapshots-share-account/
inputs = {
  namespace                 = "dbp"
  stage                     = ""
  name                      = "api"
  domain_name               = "bwfloodlearnaws.com"
  subject_alternative_names = ["beanstalk-dev.bwfloodlearnaws.com"]
}