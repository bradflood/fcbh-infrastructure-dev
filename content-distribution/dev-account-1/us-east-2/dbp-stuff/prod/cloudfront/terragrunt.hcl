# Legacy Cloudfront configuration 

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../fcbh-infrastructure-modules//cloudfront"
  #source = "git::https://github.com/bradflood/fcbh-infrastructure-modules.git?ref=master"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

# this is unique -- CloudFront certificates must be issued in region us-east-1
dependency "certificate" {
  config_path = "../certificate/cloudfront"
}


inputs = {
  aws_region               = "us-east-2"
  namespace                = "bwf"
  stage                    = "dev"
  name                     = "cloudfront"
  price_class              = "PriceClass_200"
  aliases                  = ["cloudfront-dbp.bwfloodstudyaws.com"]
  log_prefix               = "cloudfront/dbp-dev"
  acm_certificate_arn      = dependency.certificate.outputs.arn
  minimum_protocol_version = "TLSv1.1_2016"
  cors_allowed_origins     = ["*.bwfloodstudyaws.com"]
  viewer_protocol_policy   = "allow-all"
  origin_force_destroy     = true
}

/*
smooth streaming: true for video. 
*/
