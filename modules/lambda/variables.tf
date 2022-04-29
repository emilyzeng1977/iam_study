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
}

variable "vpc_security_group_id" {
  description = "Security group ids when Lambda Function should run in the VPC"
  type        = string
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

variable "dist_path" {
  description = "It's the dist path for compiled go."
  type        = string
}

variable "kms_key_val" {
  description = "The last kms key value like (834f524e-b2c2-4146-b98d-be77e976483c)"
  type        = string
}

variable "managed_policy_arns" {
  description = "The AWS managed policy arn's list"
  type        = list(string)
}


variable "tags" {
  description = "Tags to apply to the keys."
  type        = map(string)
}

locals {
  # Bucket_name used to save lambda zip file
  bucket_name     = format("lambdas-%s.identitii.com", var.account_id)
  # Lambda
  function_name    = format("%s-%s-%s", var.service, var.stage, var.handler)
  cmd_check        = "make check"
  cmd_build        = "make build"
  cmd_cp_otel      = format("cp otel-collector-config.yaml %s", var.dist_path)
  cmd_cd_dist_path = format("cd %s", var.dist_path)

  SSM_ARN      = format("arn:aws:ssm:%s:%s:parameter/%s/*", var.aws_region, var.account_id, var.stage)
  # IAM
  inline_policy_name = format("%s-%s-%s", var.service, var.stage, var.handler)
  inline_policy_tpl_filename = format("template/%s.tpl", var.handler)
  lambda_role_name   = var.handler == "create-customer" ? format("%s-%s-%s-lambdaRole", var.service, var.stage, var.aws_region) : format("%s-%s-%s-%s-lambdaRole", var.service, var.stage, var.handler, var.aws_region)

  KMS_KEY = format("arn:aws:kms:%s:%s:key/%s", var.aws_region, var.account_id, var.kms_key_val)
  # Otel
  sdk_layer_arns_amd64 = format("arn:aws:lambda:%s:901920570463:layer:aws-otel-collector-amd64-ver-0-45-0:2", var.aws_region)
}
