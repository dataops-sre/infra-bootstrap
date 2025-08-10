
locals {
  # Automatically load provider-level variables
  provider_vars = read_terragrunt_config(find_in_parent_folders("provider.hcl"))

  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Extract the variables we need for easy access
  aws_region   = local.account_vars.locals.aws_region
  environment  = local.account_vars.locals.environment
  # Serialize provider_wide_tags into a format suitable for the provider block
  provider_tags = jsonencode(local.provider_vars.locals.provider_wide_tags)
}

# Generate an AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.aws_region}"

  default_tags {
    tags = ${local.provider_tags}
  }
}
EOF
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    #generated name, change it
    bucket = "data-platform-iac-template-${local.environment}-tfstate"
    key    = "${basename(get_parent_terragrunt_dir())}/${path_relative_to_include()}/terraform.tfstate"
    region = "eu-west-1"
    #generated name, change it
    dynamodb_table ="data-platform-iac-template-${local.environment}-tfstate-lock"
    encrypt        = true
  }
}

prevent_destroy = false

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = merge(
  local.account_vars.locals,
  local.provider_vars.locals,
)
