variable "enable" {
  description = "Toggle to use or not use the lambda"
  type        = bool
  default     = true
}

variable "account_id" {
  description = "Account id"
  type        = string
}

variable "service" {
  description = "Service name for your Lambda"
  type        = string
}

variable "stage" {
  description = "Stage for your Lambda"
  type        = string
}

variable "aws_region" {
  description = "AWS region for your Lambda"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the keys."
  type        = map(string)
}

###########
# Function
###########

variable "handler" {
  description = "A handler name for your Lambda"
  type        = string
}

variable "description" {
  description = "Description for your Lambda Function"
  type        = string
}

variable "runtime" {
  description = "Lambda Function runtime"
  type        = string
}

variable "tracing_mode" {
  type        = string
  description = "Lambda function tracing mode"
  default     = "PassThrough"
}

variable "log_level" {
  type        = string
  description = "Log level for Lambda"
  default     = "error"
}

variable "vpc_subnet_id" {
  description = "Subnet id when Lambda Function should run in the VPC. Usually private or intra subnets."
  type        = string
  default     = ""
}

variable "vpc_security_group_id" {
  description = "Security group ids when Lambda Function should run in the VPC"
  type        = string
  default     = ""
}

variable "memory_size" {
  description = "Memory size for lambda function"
  type        = number
  default     = 1024
}

variable "timeout" {
  description = "Timeout for lambda function"
  type        = number
}

variable "environment_variables" {
  description = "Environment variables for stage"
  type        = map
}

###########
# Go related
###########

variable "dist_path" {
  description = "It's the dist path for compiled go."
  type        = string
}

###########
# Policies
###########

# Predefined policies
variable "attach_policies" {
  description = "Controls whether list of policies should be added to IAM role for Lambda Function"
  type        = bool
}

variable "number_of_policies" {
  description = "Number of policies to attach to IAM role for Lambda Function"
  type        = number
}

variable "policies" {
  description = "List of policy statements ARN to attach to Lambda Function role"
  type        = list(string)
}

# Inline policies
variable "attach_policy_statements" {
  description = "Controls whether policy_statements should be added to IAM role for Lambda Function"
  type        = bool
}

variable "policy_statements" {
  description = "Map of dynamic policy statements to attach to Lambda Function role"
  type        = map
}

#############################
# Lambda Event Source Mapping
#############################

variable "event_source_mapping" {
  description = "Map of event source mapping"
  type        = map
}

##############################################
# Lambda EventBridge (Schedule) Source Mapping
##############################################

variable "schedules" {
  description = "schedule expression list"
  type        = list(string)
  default     = []
}

locals {
  # Bucket_name used to save lambda zip file
  bucket_name     = format("lambdas-%s.identitii.com", var.account_id)
  # Lambda
  function_name    = format("%s-%s-%s", var.service, var.stage, var.handler)
  cmd_build        = "make build"
  cmd_cp_otel      = format("cp otel-collector-config.yaml %s", var.dist_path)
  cmd_cd_dist_path = format("cd %s", var.dist_path)

  # IAM (we will use the same naming convention as the serverless framework)
  lambda_role_name = format("%s-%s-%s-%s-lambdaRole123", var.service, var.stage, var.handler, var.aws_region)

  # Otel
  sdk_layer_arns_amd64 = format("arn:aws:lambda:%s:901920570463:layer:aws-otel-collector-amd64-ver-0-45-0:2", var.aws_region)
  environment_variables = merge(var.environment_variables, {
    log_level = var.log_level
    AWS_LAMBDA_EXEC_WRAPPER = "/opt/otel-instrument"
    OPENTELEMETRY_COLLECTOR_CONFIG_FILE = "/var/task/otel-collector-config.yaml"
  })
  policy_statements = merge(var.policy_statements, {
    xray = {
      effect    = "Allow",
      actions   = ["xray:PutTraceSegments", "xray:PutTelemetryRecords"],
      resources = ["*"]
    }
  })

  #############################
  # EventBridge (Schedule task)
  #############################
  # Schedule task
  lambda_arn = format("arn:aws:lambda:%s:%s:function:%s", var.aws_region, var.account_id, local.function_name)

  # Create rule list
  rule_list = [
    for schedule in var.schedules : replace(schedule, "/\\W/", "")
  ]

  # Create map of allowed_triggers for Lambda
  allowed_triggers = {
    for rule in local.rule_list : format("ScanAmi%s", rule) => {
      principal  = "events.amazonaws.com"
      source_arn = format("arn:aws:events:%s:%s:rule/%s-rule", var.aws_region, var.account_id, rule)
    }
  }

  # Create map of rules for EventBridge
  rules = {
    for schedule in var.schedules : replace(schedule, "/\\W/", "") => {
      description         = "Trigger for a Lambda"
      schedule_expression = schedule
    }
  }

  # Create map of targets for EventBridge
  targets = {
    for rule in local.rule_list : rule => [
      {
        name = rule
        arn  = local.lambda_arn
      }
    ]
  }
}
