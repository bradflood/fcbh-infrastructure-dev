# Legacy Cloudfront configuration 

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../../fcbh-infrastructure-modules//cloudfront"
  #source = "git::https://github.com/bradflood/fcbh-infrastructure-modules.git?ref=master"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

inputs = {

  namespace = "dbp"
  stage     = "testSTAGE"
  name      = "testNAME"
  parent_zone_name = "foo"

}


# DBS

#dbp-api
# terragrunt import module.cloudfront_s3_cdn.aws_cloudfront_distribution.default ESTX6CKWMHOBF
#terragrunt import module.cloudfront_s3_cdn.aws_cloudfront_origin_access_identity.default E2X79Y8LNMXOG8


### terragrunt import module.cloudfront_s3_cdn.aws_s3_bucket.origin[0]
