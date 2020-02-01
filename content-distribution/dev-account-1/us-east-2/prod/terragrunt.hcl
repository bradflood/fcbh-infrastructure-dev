# root of dbp prod
remote_state {
  backend = "s3"
  config = {
    bucket = "terraform-state-fcbh-dbp-prod${get_env("TG_BUCKET_PREFIX", "")}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "my-lock-table"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are automatically merged into the child
# `terragrunt.hcl` config via the include block.
# ---------------------------------------------------------------------------------------------------------------------

locals {
  default_yaml_path = find_in_parent_folders("empty.yaml")
}

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = merge(
  # Configure Terragrunt to use common vars encoded as yaml to help you keep often-repeated variables (e.g., account ID)
  # DRY. We use yamldecode to merge the maps into the inputs, as opposed to using varfiles due to a restriction in
  # Terraform >=0.12 that all vars must be defined as variable blocks in modules. Terragrunt inputs are not affected by
  # this restriction.
  yamldecode(
    file("${get_terragrunt_dir()}/${find_in_parent_folders("account.yaml", local.default_yaml_path)}"),
  ),
  yamldecode(
    file("${get_terragrunt_dir()}/${find_in_parent_folders("region.yaml", local.default_yaml_path)}"),
  ),
  yamldecode(
    file("${get_terragrunt_dir()}/${find_in_parent_folders("env.yaml", local.default_yaml_path)}"),
  ),
  {
    namespace   = "dbp",
    stage       = "non-prod"
  },
)


#
# aws_region: region in which organization resources will be created
# 
# aws_profile: refers to a named profile (https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) 
# with sufficient permissions to create resources in the master account. 
#
# inputs = {
#   aws_region  = "us-east-2"
#   aws_account = 
#   aws_profile = "contrib-kh-admin"
#   namespace   = "dbp"
#   stage       = "non-prod"

# }
