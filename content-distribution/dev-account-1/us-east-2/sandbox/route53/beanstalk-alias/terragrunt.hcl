# member-account: dbp-dev

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../../../../fcbh-infrastructure-modules//route53/alias"
  #source = "git::https://github.com/faithcomesbyhearing/fcbh-infrastructure-modules.git?ref=master"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependency "beanstalk" {
  config_path = "../../beanstalk"
}

inputs = {

  namespace = "bwflood"
  stage     = "dev"
  name      = ""

  aliases         = ["beanstalk.dev.bwfloodstudyaws.com"]
  # parent_zone_id  = var.parent_zone_id
  target_zone_id  = dependency.beanstalk.outputs.zone_id
  target_dns_name = dependency.beanstalk.outputs.hostname
}
