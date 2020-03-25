# bibleis web

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../../../../fcbh-infrastructure-modules//elastic-beanstalk"
  #source = "git::https://github.com/faithcomesbyhearing/fcbh-infrastructure-modules.git?ref=master"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
}
dependency "loadbalancer_certificate" {
  config_path = "../certificates/v2.bwfloodstudyaws.com"
}


inputs = {
  # administrative, to match cloudposse label
  namespace               = "bibleis"
  name                    = "web"
  stage                   = "dev"
  force_destroy           = true # force destroy s3 bucket for eb logs. use this for dev only  
  application_description = "Bible.is Web"

  # dns_zone_id        = "Z2ROOWAVSOOVLL" # don't assume a subdomain
  enable_stream_logs = true

  vpc_id                     = dependency.vpc.outputs.vpc_id
  public_subnets             = dependency.vpc.outputs.public_subnet_ids
  private_subnets            = dependency.vpc.outputs.private_subnet_ids
  # allowed_security_groups    = [dependency.bastion.outputs.security_group_id, dependency.vpc.outputs.vpc_default_security_group_id]
  # additional_security_groups = [dependency.bastion.outputs.security_group_id]
  # keypair                    = "bibleis"

  description = "Bible.is Web"
  instance_type = "t3.small"

  environment_description = "Bible.is Web Prod"
  version_label           = ""
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

  healthcheck_url     = "/"
  application_port    = 80
  nat_gateway_enabled = true
  solution_stack_name = "64bit Amazon Linux 2018.03 v4.11.0 running Node.js"

  // https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html
  additional_settings = [

  ]

  env_vars = {
    "npm_config_unsafe_perm" = "1"
    "NODE_ENV"               = "dev"
    "BASE_API_ROUTE"         = "https://api.v4.dbt.io"


    # "APP_ENV"            = "prod"
    # "APP_URL"            = "https://v4.dbt.io"
    # "API_URL"            = "https://api.v4.dbt.io"
    # "APP_URL_PODCAST"    = "https://v4.dbt.io"
    # "APP_DEBUG"          = "0"
    # "DBP_HOST"           = dependency.rds.outputs.reader_endpoint
    # "DBP_USERNAME"       = "api_node_dbp"
    # "DBP_USERS_HOST"     = dependency.rds.outputs.endpoint
    # "DBP_USERS_DATABASE" = "dbp_users"
    # "DBP_USERS_USERNAME" = "api_node_dbp"
    # "MEMCACHE_HOST"      = dependency.elasticache.outputs.cluster_configuration_endpoint
  }
}
