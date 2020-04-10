# member-account: dbp

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../../../fcbh-infrastructure-modules//elastic-beanstalk"
  # source = "git::https://github.com/faithcomesbyhearing/fcbh-infrastructure-modules.git?ref=master"
}

#Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependency "route53" {
  config_path = "../route53/hosted-zone-dev"
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "certificate" {
  config_path = "../certificate/beanstalk"
}

# to copy an RDS snapshot between accounts: https://aws.amazon.com/premiumsupport/knowledge-center/rds-snapshots-share-account/
inputs = {
  namespace                     = "bwflood"
  stage                         = "dev"
  name                          = "beanstalk"
  application_description       = "wordpress"
  vpc_id                        = dependency.vpc.outputs.vpc_id
  public_subnets                = dependency.vpc.outputs.public_subnet_ids
  private_subnets               = dependency.vpc.outputs.private_subnet_ids
  allowed_security_groups       = [dependency.vpc.outputs.vpc_default_security_group_id]
  keypair                       = "dbp"
  availability_zones            = dependency.vpc.outputs.availability_zones

  description                = "Wordpress beanstalk"
  availability_zone_selector = "Any 2"
  dns_zone_id                = dependency.route53.outputs.zone_id
  instance_type              = "t3.small"

  environment_description = "test"
  version_label           = ""
  force_destroy           = true
  root_volume_size        = 8
  root_volume_type        = "gp2"

  autoscale_min             = 2
  autoscale_max             = 3
  autoscale_measure_name    = "CPUUtilization"
  autoscale_statistic       = "Average"
  autoscale_unit            = "Percent"
  autoscale_lower_bound     = 20
  autoscale_lower_increment = -1
  autoscale_upper_bound     = 80
  autoscale_upper_increment = 1

  rolling_update_enabled  = true
  rolling_update_type     = "Health"
  updating_min_in_service = 0
  updating_max_batch      = 1

  healthcheck_url  = "/"
  application_port = 80

  solution_stack_name = "64bit Amazon Linux 2018.03 v2.9.2 running PHP 7.2"

}
