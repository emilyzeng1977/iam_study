include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_path_to_repo_root()}//modules/step-functions"
}

locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  account_id  = local.account_vars.locals.aws_account_id
  aws_region = local.region_vars.locals.aws_region
  service   = local.env_vars.locals.SERVICE
  stage   = local.env_vars.locals.SLS_STAGE
  vpc_security_group_id = local.env_vars.locals.VPC_SECURITY_GROUP_ID
  vpc_subnet_id = local.env_vars.locals.VPC_SUBNET_ID
}

inputs = {
  step_function_prefix = "NewCustomerProvisioningFlowStepFunctionsStateMachine"
  handler = "create-customer"

  random_id  = "BS3iErQGyl1y"
  service    = local.service
  stage   = local.stage
  account_id = local.account_id

  definition = templatefile("../../../../../workflow/customer-onboarding/definition.tpl", {
    aws_region = local.aws_region,
    account_id = local.account_id,
    function_name = format("%s-%s-%s", local.service, local.stage, "create-customer")
  })

  tags = {
    "Managed By" = "Terragrunt"
  }
}
