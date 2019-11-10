# Legacy Cloudfront configuration 

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../fcbh-infrastructure-modules//cloudfront"
  #source = "git::https://github.com/bradflood/fcbh-infrastructure-modules.git?ref=master"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

inputs = {

  namespace                = "bwf"
  stage                    = "prod"
  name                     = "cloudfront"
  parent_zone_id           = "Z2ROOWAVSOOVLL" 
  # aliases                  = ["content.cdn.dbp-prod.bwfloodstudyaws.com"]
  log_prefix               = "content.cdn.dbp-prod"
  #acm_certificate_arn      = "arn:aws:acm:us-east-1:869054869504:certificate/4539f7c5-8446-4280-8c50-bda88bad4221"
  minimum_protocol_version = "TLSv1.1_2016"
  cors_allowed_origins     = ["*.bwfloodstudyaws.com"]
}




/*
smooth streaming: true for video. Need to configure ordered_cache_behavior, which is not configurable with cloud_posse currently
*/
