# Organization: FCBH
#      Organizational Unit: Content Distribution

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../fcbh-infrastructure-modules//organizational-unit"
}

# #Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}
dependency "organization" {
  config_path = "../fcbh"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  organization_id                     = dependency.organization.outputs.organization_id
  organization_unit_name              = "Content Distribution"
}