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

variable "rest_api_description" {
  description = "Description of the REST API"
  type        = string
}

variable "api_version" {
  description = "Version of the REST API"
  type        = string
}

variable "path_parts" {
  description = "The last path segment of this API resource"
  type        = list(string)
}

variable "http_methods" {
  description = "The HTTP Method (GET, POST, PUT, DELETE, HEAD, OPTIONS, ANY)"
  type        = list(string)
}

variable "integration_http_methods" {
  description = "Integration Http Method (GET, POST, PUT, DELETE, HEAD, OPTIONS, ANY)"
  type        = list(string)
}

variable "uri_list" {
  description = "URI list"
  type        = list(string)
}

variable "template_list" {
  description = "template list"
  type        = list(string)
}

variable "aws_service_arn_list" {
  description = "AWS service arn list"
  type        = list(string)
}

variable "iam_execution_roles" {
  description = "API gateway role execution list"
  type        = list(string)
}

variable "authorizations" {
  description = "The type of authorization used for the method (NONE, CUSTOM, AWS_IAM, COGNITO_USER_POOLS)"
  type        = list(string)
}

variable "types" {
  description = "The type of service"
  type        = list(string)
}

variable "passthrough_behaviors" {
  description = "If pass through for the request"
  type        = list(string)
}

variable "auto_deploy" {
  description = "If deploy to stage automatically when any changes on resources, methods and AWS services"
  type        = bool
  default     = true
}

variable "stage_names" {
  description = "The stage name list"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to the keys"
  type        = map(string)
}

locals {
  rest_api_name = format("%s-%s", var.stage, var.service)
}
