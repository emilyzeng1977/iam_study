module "lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "3.1.0"

  count = var.enable ? 1 : 0

  function_name = local.function_name
  description   = var.description
  handler       = var.handler
  runtime       = var.runtime

  memory_size = var.memory_size
  timeout     = var.timeout

  publish = true

  store_on_s3 = true
  s3_bucket   = data.aws_s3_bucket.bucket_for_lambda.bucket

  vpc_subnet_ids         = [var.vpc_subnet_id]
  vpc_security_group_ids = [var.vpc_security_group_id]

  source_path = [
    {
      path = "${path.module}/../..",
      commands = [
        local.cmd_build,
        local.cmd_cp_otel,
        local.cmd_cd_dist_path,
        ":zip"
      ]
    }
  ]

  environment_variables = local.environment_variables

  ###################
  # role and policies
  ###################
  create_role = true
  role_name = local.lambda_role_name

  attach_policies = var.attach_policies
  number_of_policies = var.number_of_policies
  policies = var.policies

  attach_policy_statements = var.attach_policy_statements
  policy_statements = local.policy_statements

  ###########
  # honeycomb
  ###########
  layers = compact([local.sdk_layer_arns_amd64])
  tracing_mode = var.tracing_mode

  ###########
  # Event
  ###########
  event_source_mapping = var.event_source_mapping

  allowed_triggers = {
    ScanAmiRule = {
      principal  = "events.amazonaws.com"
      source_arn = module.eventbridge.eventbridge_rule_arns["crons"]
    }
  }

  tags = var.tags

  depends_on = [module.eventbridge]
}

module "eventbridge" {
  source = "terraform-aws-modules/eventbridge/aws"
  version = "1.14.0"

  create_bus = false

  rules = {
    crons = {
      description         = "Trigger for a Lambda"
      schedule_expression = "rate(5 minutes)"
    }
  }

  targets = {
    crons = [
      {
        name  = "lambda-cron"
        arn   = local.lambda_arn
      }
    ]
  }

  tags = var.tags
}
