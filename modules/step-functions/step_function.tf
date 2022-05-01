module "step_function" {
  source  = "terraform-aws-modules/step-functions/aws"
  version = "2.7.0"

  name       = local.step_function_name
#  definition = data.template_file.new-customer-defination.rendered
  definition = var.definition

  use_existing_role = true
  role_arn = data.aws_iam_role.NewCustomerProvisioningFlowRole.arn

  type = "STANDARD"
  tags = var.tags

  depends_on = [data.template_file.new-customer-defination, data.aws_iam_role.NewCustomerProvisioningFlowRole]
}

data "template_file" "new-customer-defination" {
  template = file("template/create-customer-defination.tpl")

  vars = {
    aws_region    = var.aws_region
    account_id    = var.account_id
    function_name = local.function_name
  }
}

data "aws_iam_role" "NewCustomerProvisioningFlowRole" {
  name = "NewCustomerProvisioningFlowRole"
}

output "state_machine_arn" {
  value = module.step_function.state_machine_arn
}
