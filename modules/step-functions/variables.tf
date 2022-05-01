variable "account_id" {
  description = "Account id"
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

variable "step_function_prefix" {
  description = "Step functions prefix name"
  type        = string
}

variable "random_id" {
  description = "random_id for Step functions"
  type        = string
}

variable "handler" {
  description = "A handler name for your Step function"
  type        = string
  default     = ""
}

variable "aws_region" {
  description = "AWS region for your Step function"
  type        = string
}

variable "definition" {
  description = "AWS region for your Step function"
  type        = string
}

variable "tags" {
  description = "Tags to apply to buckets"
  type        = map(string)
  default = {
    "Managed By" = "Terraform"
  }
}

locals {
  step_function_name = format("%s-%s", var.step_function_prefix, var.random_id)
  function_name      = format("%s-%s-%s", var.service, var.stage, var.handler)
}
