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

inputs = {

  namespace      = "bwf"
  stage          = "prod"
  name           = "cloudfront"
  parent_zone_id = "Z2ROOWAVSOOVLL"
  price_class    = "PriceClass_200"
  # aliases                  = ["content.cdn.dbp-prod.bwfloodstudyaws.com"]
  log_prefix = "cloudfront/dbp-prod/content.cdn.dbp-prod"
  #acm_certificate_arn      = "arn:aws:acm:us-east-1:869054869504:certificate/4539f7c5-8446-4280-8c50-bda88bad4221"
  minimum_protocol_version = "TLSv1.1_2016"
  cors_allowed_origins     = ["*.bwfloodstudyaws.com"]
  viewer_protocol_policy   = "allow-all"
  ordered_cache = [
    {
      path_pattern                = "'mp3audiobibles2/*'"
      allowed_methods             = ["GET", "HEAD", "OPTIONS"]
      cached_methods              = ["OPTIONS"]
      compress                    = true
      min_ttl                     = 0
      max_ttl                     = 86400 #31536000
      default_ttl                 = 86400
      forward_cookies             = "'none'"
      forward_header_values       = ["Access-Control-Request-Headers", "Access-Control-Request-Method", "Origin"]
      forward_query_string        = false
      lambda_function_association = []
      viewer_protocol_policy      = "allow-all" #"redirect-to-https"
    }
  ]
}




/*
smooth streaming: true for video. 
*/
