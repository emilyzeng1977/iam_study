include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_path_to_repo_root()}//modules/lambda"
}

locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

inputs = {
  handler       = "seeder"
  description   = "Seeder service"
  runtime       = "go1.x"
  dist_path     = "dist/seeder_linux_amd64",

  service   = local.env_vars.locals.SERVICE
  stage   = local.env_vars.locals.SLS_STAGE
  vpc_security_group_id = local.env_vars.locals.VPC_SECURITY_GROUP_ID
  vpc_subnet_id = local.env_vars.locals.VPC_SUBNET_ID
  kms_key_val = local.env_vars.locals.KMS_KEY_VAL
  aws_region = local.region_vars.locals.aws_region
  account_id  = local.account_vars.locals.aws_account_id

  timeout       = 520
  tracing_mode  = "Active"

  tags = {
    "Managed By" = "Terragrunt"
  }
}
