# member-account: dbp

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../../../fcbh-infrastructure-modules//data-storage/rds"
  # source = "git::https://github.com/bradflood/fcbh-infrastructure-modules.git?ref=master"
}

#Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
}
dependency "bastion" {
  config_path = "../bastion"
}

#
# aws_region: region in which organization resources will be created
# 
# aws_profile: refers to a named profile (https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) 
# with sufficient permissions to create resources in the master account. 
#
# to copy an RDS snapshot between accounts: https://aws.amazon.com/premiumsupport/knowledge-center/rds-snapshots-share-account/
inputs = {
  namespace           = "dbp"
  stage               = ""
  name                = "api"
  vpc_id              = dependency.vpc.outputs.vpc_id
  subnets             = dependency.vpc.outputs.private_subnet_ids
  security_groups     = [dependency.vpc.outputs.vpc_default_security_group_id, dependency.bastion.outputs.security_group_id]
  db_name             = "henry"
  snapshot_identifier = "mysnapshot"
  #snapshot_identifier = arn:aws:rds:us-east-2:627672411722:cluster-snapshot:mysnapshot
}


#mysql -h dbp-api.cluster-c0vue8dkagvy.us-east-2.rds.amazonaws.com -u sa -p 
#password Test123456789
