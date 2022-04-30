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
  handler       = "customer-projector"
  description   = "Customer-projector service"
  runtime       = "go1.x"
  dist_path     = "dist/customer-projector_linux_amd64",

  service   = local.env_vars.locals.SERVICE
  stage   = local.env_vars.locals.SLS_STAGE
  vpc_security_group_id = local.env_vars.locals.VPC_SECURITY_GROUP_ID
  vpc_subnet_id = local.env_vars.locals.VPC_SUBNET_ID
//  kms_key_val = local.env_vars.locals.KMS_KEY_VAL
  aws_region = local.region_vars.locals.aws_region
  account_id  = local.account_vars.locals.aws_account_id

  timeout       = 120
  tracing_mode  = "Active"

  # we will need AWSLambdaVPCAccessExecutionRole when vpc_subnet_id is not empty
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"]
  dynamo_kms_key_val = ""
  kinesis_kms_key_val = ""
  kms_key_val = ""

  policy_statements = {
    dynamodb = {
      effect    = "Deny",
      actions   = ["dynamodb:BatchWriteItem"],
      resources = ["arn:aws:dynamodb:eu-west-1:052212379155:table/Test"]
    },
    s3_read = {
      effect    = "Allow",
      actions   = ["s3:HeadObject"],
      resources = ["arn:aws:s3:::my-bucket/*"]
    }
  }

  tags = {
    "Managed By" = "Terragrunt"
  }
}
