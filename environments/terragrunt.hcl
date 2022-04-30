# iam_role = "arn:aws:iam::211817836436:role/TerraformAdmin"

locals {
  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Automatically load environment-level variables - we don't need this, each account is an env!
  # environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract the variables we need for easy access
  account_id = local.account_vars.locals.aws_account_id
  aws_region = local.region_vars.locals.aws_region

  state_bucket_region = "ap-southeast-2"
}

remote_state {
  backend = "s3"
  generate = {
    path      = "_backend.tf"
    if_exists = "overwrite"
  }
  config = {
    encrypt        = true
    region         = local.state_bucket_region
    key            = "${path_relative_to_include()}/terraform.tfstate"
    bucket         = "tfstate-${local.account_id}.identitii.com"
    dynamodb_table = "tfstate-${local.account_id}"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "aws" {
  region = "${local.aws_region}"
  # Only these AWS Account IDs may be operated on by this template
  allowed_account_ids = ["${local.account_id}"]
}
EOF
}

inputs = merge(
  local.account_vars.locals,
  local.region_vars.locals,
  # local.environment_vars.locals,
)
