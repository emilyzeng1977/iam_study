include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_path_to_repo_root()}//modules/step-functions"
}

locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
}

inputs = {
  step_function_prefix = "NewCustomerProvisioningFlowStepFunctionsStateMachine"
  handler = "create-customer"

  random_id  = "BS3iErQGyl1y"
  service    = local.env_vars.locals.SERVICE
  stage   = local.env_vars.locals.SLS_STAGE
  account_id = local.account_vars.locals.aws_account_id

  tags = {
    "Managed By" = "Terragrunt"
  }
}
