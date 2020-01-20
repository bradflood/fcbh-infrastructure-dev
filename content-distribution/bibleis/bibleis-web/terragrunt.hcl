# bibleis dbp-web

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../fcbh-infrastructure-modules//elastic-beanstalk"
  #source = "git::https://github.com/bradflood/fcbh-infrastructure-modules.git?ref=master"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependency "load_balancer_certificate" {
  config_path = "../certificates/elmo.bwfloodstudyaws.com"
}

inputs = {

  # administrative, to match cloudposse label
  namespace = "bibleis"
  name      = "web"
  stage     = "dev"
  force_destroy = true # force destroy s3 bucket for eb logs. use this for dev only
  loadbalancer_certificate_arn = dependency.load_balancer_certificate.outputs.arn

  # module-specific, sorted alphabetically

  // https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html
  additional_settings = [
    {
      name      = "XRayEnabled"
      namespace = "aws:elasticbeanstalk:xray"
      value     = "true"
    },


    # specific to the Beanstalk platform (Node.js)
    {
      name      = "NodeVersion"
      namespace = "aws:elasticbeanstalk:container:nodejs"
      value     = "10.15.1"
    },    
    # {
    #   name      = "NodeCommand"
    #   namespace = "aws:elasticbeanstalk:container:nodejs"
    #   value     = "./node_modules/.bin/cross-env NODE_ENV=production node nextServer"
    # },


    {
      namespace = "aws:cloudformation:template:parameter"
      name      = "EnvironmentVariables"
      value     = "npm_config_unsafe_perm=1,NODE_ENV=production,BASE_API_ROUTE=https://api.v4.dbt.io"
    },

    {
      name      = "AppSource"
      namespace = "aws:cloudformation:template:parameter"
      value     = "http://s3-us-west-2.amazonaws.com/elasticbeanstalk-samples-us-west-2/nodejs-sample-v2.zip"
    }


    # is a keypair needed if we enable SSM Session Manager? or is there another reason the keypair is needed
    # {
    #   namespace = "aws:autoscaling:launchconfiguration"
    #   name      = "EC2KeyName"
    #   value     = "reader-web-stage"
    # },

  ]

  application_description = "bibleis Web Elastic Beanstalk Application"
  availability_zones      = ["us-east-2a", "us-east-2b"]
  dns_zone_id             = "Z2ROOWAVSOOVLL"
  enable_stream_logs      = true
    # TODO: is this duplicating aws:cloudformation:template:parameter (lines 82-84)?
  # env_vars = {
  #   "BASE_API_ROUTE"         = "https://api.v4.dbt.io"
  #   "NODE_ENV"               = "dev"
  #   "npm_config_unsafe_perm" = "1"
  # }
  environment_description = "bibleis Web Blue"
  #healthcheck_url = "/bible/ENGESV/MAT/1"  # uncomment when app is deployed. default is /, which is find for sample app
  instance_type           = "t3.small"
  loadbalancer_type       = "application"
  logs_retention_in_days  = 60
  nat_gateway_enabled     = true
  rolling_update_type     = "Health" # With Immutable, issues, maybe unrelated to Immutable
  solution_stack_name     = "64bit Amazon Linux 2018.03 v4.11.0 running Node.js"

}

# need to add

# 
# add EC2 Termination Protection (probably in additionalSettings, namespace for launch configuration)
