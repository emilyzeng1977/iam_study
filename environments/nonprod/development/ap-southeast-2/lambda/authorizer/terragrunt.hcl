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

  account_id  = local.account_vars.locals.aws_account_id
  aws_region = local.region_vars.locals.aws_region
  service   = local.env_vars.locals.SERVICE
  stage   = local.env_vars.locals.SLS_STAGE
  vpc_security_group_id = local.env_vars.locals.VPC_SECURITY_GROUP_ID
  vpc_subnet_id = local.env_vars.locals.VPC_SUBNET_ID

  SSM_ARN = format("arn:aws:ssm:%s:%s:parameter/%s/*", local.aws_region, local.account_id, local.stage)
  KINESIS_ARN = format("arn:aws:kinesis:%s:%s:stream/eventstream", local.aws_region, local.account_id)
}

inputs = {
  # Fundamental information
  handler       = "authorizer"
  description   = "Authorizer service"
  runtime       = "go1.x"
  dist_path     = "dist/authorizer_linux_amd64",

  # Environment variables
  environment_variables = {
    ENV_STAGE = local.stage
    ENV_REGION = local.aws_region
    EVENT_TABLE_NAME = "events"
    SSM_ARN = local.SSM_ARN
    KINESIS_ARN =  local.KINESIS_ARN
  }

  service   = local.service
  stage   = local.stage
  aws_region = local.aws_region
  account_id  = local.account_id

  # Setup subnet and security group (so need to give lambda permission accordingly)
  vpc_security_group_id = local.vpc_security_group_id
  vpc_subnet_id = local.vpc_subnet_id

  attach_policies = true
  number_of_policies = 1
  policies = ["arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"]

  # Inline policies
  attach_policy_statements = true
  policy_statements = {
    ssm = {
      effect    = "Allow",
      actions   = ["ssm:GetParameters"],
      resources = [local.SSM_ARN]
    }
  }

  timeout       = 120
  tracing_mode  = "Active"

  tags = {
    "Managed By" = "Terragrunt"
  }
}
