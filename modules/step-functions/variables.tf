variable "account_id" {
  description = "Account id"
  type        = string
}

variable "aws_region" {
  description = "AWS region for your Step function"
  type        = string
}

variable "service" {
  description = "Service name for your Step function"
  type        = string
  default     = ""
}

variable "stage" {
  description = "Stage for your Step function"
  type        = string
}

variable "step_function_suffix" {
  description = "Step functions suffix name"
  type        = string
}

variable "definition" {
  description = "AWS region for your Step function"
  type        = string
}

##########
# Policies
##########

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

variable "tags" {
  description = "Tags to apply to buckets"
  type        = map(string)
  default = {
    "Managed By" = "Terraform"
  }
}

locals {
  step_function_name = format("%s-%s-%s", var.service, var.stage,var.step_function_suffix)
}
