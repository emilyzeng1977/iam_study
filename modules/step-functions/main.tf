module "step_function" {
  source  = "terraform-aws-modules/step-functions/aws"
  version = "2.7.0"

  name       = local.step_function_name
  definition = var.definition

  use_existing_role = true
  role_arn = data.aws_iam_role.NewCustomerProvisioningFlowRole.arn

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
