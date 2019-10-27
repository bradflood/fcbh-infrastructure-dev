# Organization: DBP
#      Organizational Unit: Content Distribution
#           Member Account: bible.is

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../fcbh-infrastructure-modules//member-account"
}

# #Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}
dependency "organizational-unit" {
  config_path = "../ou-content-distribution"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  parent_id                           = dependency.organizational-unit.outputs.organizational_unit_id
  member_account_name                 = "bible.is"
  member_account_email                = "bflood@keyholesoftware.com"
  iam_users_accessing_member_account  = ["bwflood"]
  role_arn_referencing_member_account = { "bibleis" = "arn:aws:iam::529323115138:role/OrganizationAccountAccessRole" }
  namespace                           = "dev-namespace"
  stage                               = "dev-stage"
  name                                = "org-access-to-bibleis"
}
