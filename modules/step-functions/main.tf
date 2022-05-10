module "step_function" {
  source  = "terraform-aws-modules/step-functions/aws"
  version = "2.7.0"

  name       = local.step_function_name
  definition = var.definition

//  use_existing_role = true
//  role_arn = data.aws_iam_role.NewCustomerProvisioningFlowRole.arn

  attach_policies = var.attach_policies
  number_of_policies = var.number_of_policies
  policies = var.policies

  attach_policy_statements = var.attach_policy_statements
  policy_statements = var.policy_statements

  type = "STANDARD"
  tags = var.tags

  depends_on = [data.aws_iam_role.NewCustomerProvisioningFlowRole]
}

data "aws_iam_role" "NewCustomerProvisioningFlowRole" {
  name = "NewCustomerProvisioningFlowRole"
}

output "state_machine_arn" {
  value = module.step_function.state_machine_arn
}
