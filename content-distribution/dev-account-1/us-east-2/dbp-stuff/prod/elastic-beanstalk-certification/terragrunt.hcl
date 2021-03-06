# member-account: dbp

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../../../../fcbh-infrastructure-modules//elastic-beanstalk"
  # source = "git::https://github.com/faithcomesbyhearing/fcbh-infrastructure-modules.git?ref=master"
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
dependency "rds" {
  config_path = "../rds"
}
#
# aws_region: region in which organization resources will be created
# 
# aws_profile: refers to a named profile (https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) 
# with sufficient permissions to create resources in the master account. 
#
# to copy an RDS snapshot between accounts: https://aws.amazon.com/premiumsupport/knowledge-center/rds-snapshots-share-account/
inputs = {
  namespace                  = "dbp"
  stage                      = "cert"
  name                       = "beanstalk"
  application_description    = "dbp"
  vpc_id                     = dependency.vpc.outputs.vpc_id
  public_subnets             = dependency.vpc.outputs.public_subnet_ids
  private_subnets            = dependency.vpc.outputs.private_subnet_ids
  allowed_security_groups    = [dependency.vpc.outputs.vpc_default_security_group_id]
  additional_security_groups = [dependency.bastion.outputs.security_group_id]
  keypair                    = "contrib-kh-admin"
  elasticache_subnet_group_name = "dbp-elasticache-subnet"  
  availability_zones            = dependency.vpc.outputs.availability_zones  

  description                = "DBP Elastic Beanstalk (Non Prod - Single instance)"
  availability_zone_selector = "Any 2"
  dns_zone_id                = "" # "Z2ROOWAVSOOVLL"
  instance_type              = "t3.small"


  environment_description = "my test environment for dbp - created by terraform"
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

  solution_stack_name = "64bit Amazon Linux 2018.03 v2.9.2 running PHP 7.2 "

  env_vars = {
    "APP_ENV"            = "cert"
    "APP_URL"            = "https://v4.dbt.io"
    "API_URL"            = "https://api.v4.dbt.io"
    "APP_URL_PODCAST"    = "https://v4.dbt.io"
    "APP_DEBUG"          = "1"
    "DBP_HOST"           = dependency.rds.outputs.reader_endpoint
    "DBP_USERNAME"       = "api_node_dbp"
    "DBP_USERS_HOST"     = dependency.rds.outputs.endpoint
    "DBP_USERS_DATABASE" = "dbp_users"
    "DBP_USERS_USERNAME" = "api_node_dbp"
  }
}

/*
defaults 
managed_actions_enabled: true (from cloudposse)
preferred_start_time
delete_on_terminate: false
delete_on_terminate_health: false
*/
